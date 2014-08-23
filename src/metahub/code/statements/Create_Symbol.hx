package metahub.code.statements;
import haxe.macro.Context;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Expression_Utility;
import metahub.code.nodes.Symbol_Node;
import metahub.code.symbols.Symbol;
import metahub.code.Type_Signature;
import metahub.engine.Empty_Context;
import metahub.engine.General_Port;
import metahub.code.nodes.Group;

class Create_Symbol implements Expression {
  public var symbol:Symbol;
  public var expression:Expression;

  public function new(symbol:Symbol, expression:Expression) {
		if (symbol == null)
			throw new Exception("Local symbol cannot be null.");

    this.symbol = symbol;
    this.expression = expression;
  }

	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var port = expression.to_port(scope, group, signature_node);
		var value = port.get_node_value(new Empty_Context(scope.hub));
		scope.set_value(symbol.index, value);
		return port;
	}

	public function get_types():Array<Array<Type_Signature>> {
		return expression.get_types();
	}

	public function to_string():String {
		return "Create_Symbol";
	}

	public function get_children():Array<Expression> {
		return expression.get_children();
	}
}