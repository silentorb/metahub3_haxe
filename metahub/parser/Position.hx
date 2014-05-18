package parser;

class Position {
  var offset:Int;
  public var y:Int;
  public var x:Int;
  public var context:Context;

  public function new(context:Context, offset:Int = 0, y:Int = 1, x:Int = 1) {
    this.context = context;
    this.offset = offset;
    this.y = y;
    this.x = x;
  }

  public function get_offset():Int {
    return offset;
  }

  public function get_coordinate_string():String {
    return y + ":" + x + (this.context.draw_offsets ? " " + offset : "");
  }

  public function move(modifier:Int):Position {
    if (modifier == 0)
      return this;

    var position = new Position(context, offset, y, x);

    var i = 0;
    if (modifier > 0) {
      do {
        if (context.text.charAt(offset + i) == "\n") {
          ++position.y;
          position.x = 1;
        }
        else {
          ++position.x;
        }
      }
      while (++i < modifier);
    }
    position.offset += modifier;
    return position;
  }

  static public function pad(depth:Int):String {
    var result = "";
    var i = 0;
    while (i++ < depth) {
      result += "  ";
    }
    return result;
  }
}