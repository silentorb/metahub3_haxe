package code.expressions;
import code.symbols.Local_Symbol;
import engine.IPort;

class Create_Symbol implements Expression {
  public var symbol:Local_Symbol;
  public var expression:Expression;
  public var type:Type_Reference;

  public function new(symbol:Local_Symbol, expression:Expression) {
    this.symbol = symbol;
    this.expression = expression;
    type = expression.type;
  }

  public function resolve(scope:Scope):Dynamic {
    var value = expression.resolve(scope);
    scope.set_value(symbol.index, value);
    return value;
  }

  public function to_port(scope:Scope):IPort {
   return null;
  }
}