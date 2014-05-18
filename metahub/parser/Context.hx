package parser;

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
    var result = definition.patterns[0].test(new Position(this), 0);
    if(result.success){
      var match:Match = cast result;
      var offset = match.start.move(match.length);
      if (!silent && offset.get_offset() < text.length)
        throw new Exception("Could not find match at " + offset.get_coordinate_string()
        + " [" + text.substr(offset.get_offset()) + "]");

    }

    return result;
  }

  public function perform_action(name:String, data:Dynamic, match:Match):Dynamic {
    return null;
  }

//  function rewind(start:Int):Match {
//    var i = history.length - 1;
//    while(i >= 0 && history[i].start >= start) {
//      --i;
//    }
//    if (i < amount)
//      return null;
//
//
//
//  }

}