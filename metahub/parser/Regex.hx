package parser;

class Regex extends Pattern {
  var regex:EReg;
  var text:String;

  public function new(text:String) {
    if (text.charAt(0) != "^")
      text = "^" + text;

    regex = new EReg(text, "");
    this.text = text;
  }

  override function __test__(start:Position, depth:Int):Result {
    if (!regex.matchSub(start.context.text, start.get_offset())) {
//      trace(Position.pad(depth) + 'regfail', text);
      return failure(start);
    }

    var match = regex.matched(0);
//    trace(Position.pad(depth) + 'reg', text, match);
    return success(start, match.length);
  }

  override function get_data(match:Match):Dynamic {
    var start = match.start;
    regex.matchSub(start.context.text, start.get_offset());
    return regex.matched(0);
  }
}