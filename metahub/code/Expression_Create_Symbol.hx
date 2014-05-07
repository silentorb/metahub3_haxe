package code;

class Expression_Create_Symbol implements Expression {
  public var symbol:Symbol;
  public var expression:Expression;
  public var type:Type_Reference;

  public function new(symbol:Symbol, expression:Expression) {
    this.symbol = symbol;
    this.expression = expression;
    type = expression.type;
  }

  public function resolve(scope:Scope):Dynamic {
    var value = expression.resolve(scope);
    scope.set_value(symbol.index, value);
    return value;
  }
}