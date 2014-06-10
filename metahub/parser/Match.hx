package parser;

class Match extends Result {
  public var length:Int;
  public var matches:Array<Match>;
  public var last_success:Match;
  public var parent:Match;

  public function new(pattern:Pattern, start:Position, length:Int = 0,
                      children:Array<Result> = null, matches:Array<Match> = null) {
    this.pattern = pattern;
    this.start = start;
    this.length = length;
    success = true;

    if (pattern.type == 'regex' || pattern.type == 'literal') {
      last_success = start.context.last_success;
      start.context.last_success = this;
    }

    this.children = children != null
    ? children
    : new Array<Result>();

    if (matches != null) {
      this.matches = matches;
      for (match in matches) {
        match.parent = this;
      }
    }
    else {
      this.matches = new Array<Match>();
    }
  }

  override public function debug_info():String {
    return start.context.text.substr(start.get_offset(), length);
  }

  public function get_data():Dynamic {
    var data = pattern.get_data(this);
    return start.context.perform_action(pattern.action, data, this);
  }


  public function get_repetition(messages:Array<String>):Match {
    if (parent == null) {
      messages.push('Parent of ' + pattern.name + " is null.");
      return null;
    }
    if (parent.pattern.type == "repetition") {
      return parent;
    }

    messages.push('Trying parent of ' + pattern.name + ".");
    return parent.get_repetition(messages);
  }


}