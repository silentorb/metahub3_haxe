package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.symbols.Local_Symbol;
import metahub.code.Type_Signature;
import metahub.engine.Context;
import metahub.engine.General_Port;

class Create_Symbol implements Statement {
  public var symbol:Local_Symbol;
  public var expression:Expression;

  public function new(symbol:Local_Symbol, expression:Expression) {
    this.symbol = symbol;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		//throw new Exception("Create_Symbol is not implemented.");
		var port = expression.to_port(scope, null, null);
    var value = port.get_node_value(new Context(null, scope.hub));
    scope.set_value(symbol.index, value);
    return value;
  }

	public function get_type():Type_Signature {
		return symbol.get_type();
	}
}