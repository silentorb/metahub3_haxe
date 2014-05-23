package parser;

class Pattern {
  public var action:String;
  public var name:String;
  public var type:String;
  public var backtrack:Bool = false;

  public function test(position:Position, depth:Int):Result {
    var result = __test__(position, depth);
    if (!result.success && backtrack) {
      var previous = position.context.last_success;
      var messages = new Array<String>();
      var new_position = previous.start.context.rewind(messages);
      previous.messages = previous.messages != null
      ? previous.messages.concat(messages)
      : messages;
      if (new_position == null)
        return result;

      return __test__(new_position, depth);
    }

    return result;
  }

  function __test__(position:Position, depth:Int):Result {
    throw new Exception("__test__ is an abstract function");
  }

  function debug_info():String {
    return "";
  }

  function failure(position:Position, children:Array<Result> = null):Failure {
    return new Failure(this, position, children);
  }

  function success(position:Position, length:Int, children:Array<Result> = null, matches:Array<Match> = null):Match {
    return new Match(this, position, length, children, matches);
  }


//  function rewind(match:Match, messages:Array<String>):Position {
//    messages.push('rewind ' + type + ' ' + name + ' ' + match.start.get_coordinate_string());
//    var previous = match.last_success;
//    if (previous == null)
//      return null;
//
//    return previous.pattern.rewind(previous, messages);
//  }

  public function get_data(match:Match):Dynamic {
    return null;
  }
}