package metahub.parser;

class Failure extends Result {

  public function new(pattern:Pattern, start:Position, end:Position, children:Array<Result> = null) {
    this.pattern = pattern;
    this.start = start;
		this.end = end;
    success = false;
    this.children = children != null
    ? children
    : new Array<Result>();
  }

}