package code;

class Expression_Literal implements Expression {
  var value:Dynamic;
  public var type:Type_Reference;

  public function new(value:Dynamic, type:Type_Reference) {
    this.value = value;
    this.type = type;
  }

  public function resolve(scope:Scope):Dynamic {
    return value;
  }
}