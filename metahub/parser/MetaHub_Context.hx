package parser;

@:expose class MetaHub_Context extends Context {

//  public function new() { }

  public override function perform_action(name:String, data:Dynamic, match:Match):Dynamic {
    switch(name) {
      case "root":
        return root();

      default:
        throw new Exception("Invalid parser method: " + name + ".");
    }

  }

  public static function root():Dynamic {
    return null;
  }
}