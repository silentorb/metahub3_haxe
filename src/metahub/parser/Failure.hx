package metahub.parser;

class Failure extends Result {

  public function new(pattern:Pattern, start:Position, children:Array<Result> = null) {
    this.pattern = pattern;
    this.start = start;
    success = false;
    this.children = children != null
    ? children
    : new Array<Result>();
  }

}