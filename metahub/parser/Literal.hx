package parser;

class Literal extends Pattern {
  var value:String;
  var text:String;

  public function new(text:String) {
    this.text = text;
  }

  override function __test__(start:Position, depth:Int):Result {
    if (start.context.text.substr(start.get_offset(), text.length) == text)
      return success(start, text.length);

    return failure(start);
  }

  override function get_data(match:Match):Dynamic {
    return text;
  }
}