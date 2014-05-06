package code;

class Expression_Create_Symbol implements Expression {
  public var expression:Expression;
  public var type:Type_Reference;
  public var name:String;

  public function new(name:String, expression:Expression) {
    this.name = name;
    this.expression = expression;
    this.type = expression.type;
  }

  public function resolve(scope:Scope):Dynamic {
    expression.resolve(scope);

    return null;
  }
}