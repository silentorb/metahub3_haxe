package parser;

class Match extends Result {
  public var length:Int;
//  public var data:Dynamic;
  public var matches:Array<Match>;
  public var last_success:Match;

  public function new(pattern:Pattern, start:Position, length:Int = 0,
                      children:Array<Result> = null, matches:Array<Match> = null) {
    this.pattern = pattern;
    this.start = start;
    this.length = length;
    success = true;

    last_success = start.context.last_success;
    start.context.last_success = this;

    this.children = children != null
    ? children
    : new Array<Result>();

    this.matches = matches != null
    ? matches
    : new Array<Match>();
  }

  override public function debug_info():String {
    return start.context.text.substr(start.get_offset(), length);
  }

  public function get_data():Dynamic {
    var data = pattern.get_data(this);
    return pattern.action != null
    ? start.context.perform_action(pattern.action, data, this)
    : data;
  }
}