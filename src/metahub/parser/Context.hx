package metahub.parser;

@:expose class Context {

  public var text:String;
  public var debug:Bool = false;
  public var draw_offsets:Bool = false;
  var definition:Definition;
//  var history:Array<Match>;
  public var last_success:Match;

  public function new(definition:Definition) {
    this.definition = definition;
  }

  public function parse(text:String, silent:Bool = true):Result {
    this.text = text;
		if (definition.patterns.length == 0)
			throw new Exception('Unable to parse; definition does not have any patterns.');

    var result = definition.patterns[0].test(new Position(this), 0);
    if(result.success){
      var match:Match = cast result;
      var offset = match.start.move(match.length);
      if (offset.get_offset() < text.length) {
				result.success = false;
				if (!silent) {
					throw new Exception("Could not find match at " + offset.get_coordinate_string()
					+ " [" + text.substr(offset.get_offset()) + "]");
				}
			}
    }

    return result;
  }

  public function perform_action(name:String, data:Dynamic, match:Match):Dynamic {
    return null;
  }

  public function rewind(messages:Array<String>) {
    var previous = last_success;
    if (previous == null) {
      messages.push('Could not find previous text match.');
      return null;
    }
    var repetition = previous.get_repetition(messages);
    var i = 0;
    while (repetition == null) {
      previous = previous.last_success;
      if (previous == null) {
        messages.push('Could not find previous text match with repetition.');
        return null;
      }
      repetition = previous.get_repetition(messages);
      if (i++ > 20)
        throw new Exception("Infinite loop looking for previous repetition.");
    }

    var pattern:Repetition = cast repetition.pattern;
    if (repetition.matches.length > pattern.min) {
      repetition.matches.pop();
      messages.push('rewinding ' + pattern.name + ' ' + previous.start.get_coordinate_string());
      repetition.children.pop();
      return previous.start;
    }

//    var previous = match.last_success;
//    if (previous == null) {
      messages.push('cannot rewind ' + pattern.name + ", No other rewind options.");
      return null;
//    }

//    messages.push('cannot rewind ' + pattern.name + ", looking for earlier repetition.");
//    return previous.pattern.rewind(previous, messages);
  }
}