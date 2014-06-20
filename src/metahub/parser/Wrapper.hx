package metahub.parser;

class Wrapper extends Pattern {
  public var pattern:Pattern;

  public function new(pattern:Pattern, action:String) {
    this.pattern = pattern;
    this.action = action;
  }

  override function __test__(start:Position, depth:Int):Result {
    var result = pattern.test(start, depth);
    if (!result.success)
      return failure(start, [ result ]);

    var match:Match = cast result;

    return success(start, match.length, [ result ], [ match ]);
  }

  override function get_data(match:Match):Dynamic {
    return match.matches[0].get_data();
  }
}