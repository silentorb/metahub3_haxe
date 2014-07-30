package metahub.parser;

class Repetition extends Pattern {
  public var min:Int;
  public var max:Int; // max < 1 is infinite
  public var pattern:Pattern;
  public var divider:Pattern;

  public function new(min:Int = 1, max = 0) {
    this.min = min;
    this.max = max;
  }

  override function __test__(start:Position, depth:Int):Result {
    var context = start.context;
    var position = start, end = position;
    var step = 0;
    var matches = new Array<Match>();
    var last_divider_length = 0;
    var length = 0;
    var info_items = new Array<Result>();
    var dividers = new Array<Match>();

    do {
      var result = pattern.test(position, depth + 1);
			if (result.end.get_offset() > end.get_offset())
				end = result.end;

			info_items.push(result);
      if (!result.success) {
          break;
      }
      var match:Match = cast result;
      position = match.start.move(match.length);
//      match.length += last_divider_length;
      length += match.length + last_divider_length;
      matches.push(match);

      ++step;

// Divider
      result = divider.test(position, depth + 1);
			if (result.end.get_offset() > end.get_offset())
				end = result.end;

      info_items.push(result);
      if (!result.success)
        break;

      match = cast result;
      dividers.push(match);
      last_divider_length = match.length;
      position = position.move(match.length);
    }
    while (max < 1 || step < max);

    if (step < min)
      return failure(start, end, info_items);

    var final = new Repetition_Match(this, start, length, info_items, matches);
		final.end = end;
    final.dividers = dividers;
    return final;
  }

//  override function rewind(match:Match, messages:Array<String>):Position {
//    if (match.matches.length > min) {
//      var previous = match.matches.pop();
//      messages.push('rewinding ' + name + ' ' + previous.start.get_coordinate_string());
//      match.children.pop();
//      return previous.start;
//    }
//
//    var previous = match.last_success;
//    if (previous == null) {
//      messages.push('cannot rewind ' + name + ", No other rewind options.");
//      return null;
//    }
//
//    messages.push('cannot rewind ' + name + ", looking for earlier repetition.");
//    return previous.pattern.rewind(previous, messages);
//  }

  override function get_data(match:Match):Dynamic {
    var result = new Array<Dynamic>();
    for (child in match.matches) {
      result.push(child.get_data());
    }
    return result;
  }
}