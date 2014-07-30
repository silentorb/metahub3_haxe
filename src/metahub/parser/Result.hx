package metahub.parser;

class Result {
  public var start:Position;
  public var children:Array<Result>;
  public var success:Bool;
  public var pattern:Pattern;
  public var messages:Array<String>;
	public var end:Position;

 public function debug_info():String {
    return "";
  }
}