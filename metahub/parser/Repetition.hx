package parser;

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
    var position = start;
    var step = 0;
    var matches = new Array<Match>();
    var last_divider_length = 0;
    var length = 0;
    var info_items = new Array<Result>();

    do {
      var result = pattern.test(position, depth + 1);
      info_items.push(result);
      if (!result.success) {
        if (matches.length == 0 || step < min)
          return failure(start, info_items);
        else {
          break;
        }
      }
      var match:Match = cast result;
      position = match.start.move(match.length);
//      match.length += last_divider_length;
      length += match.length + last_divider_length;
      matches.push(match);

// Divider
      result = divider.test(position, depth + 1);
      info_items.push(result);
      if (!result.success)
        break;

      match = cast result;
      last_divider_length = match.length;
      position = position.move(match.length);
      ++step;
    }
    while (max < 1 || step < max);

    return success(start, length, info_items, matches);
  }

  override function rewind(match:Match, messages:Array<String>):Position {
    if (match.matches.length > min) {
      var previous = match.matches.pop();
      messages.push('rewinding ' + name + ' ' + previous.start.get_coordinate_string());
      match.children.pop();
      return previous.start;
    }

    messages.push('cannot rewind ' + name);
    return null;
  }

  override function get_data(match:Match):Dynamic {
    var result = new Array<Dynamic>();
    for (child in match.matches) {
      result.push(child.get_data());
    }
    return result;
  }
}