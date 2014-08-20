package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class If_Statement implements Expression {
	var condition:Expression;
	var expression:Expression;
	
	public function new(condition:Expression, expression:Expression) {
		this.condition = condition;
		this.expression = expression;
	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_types():Array<Array<Type_Signature>>{
		return [  ];
	}

	public function to_string():String {
		return "if";
	}

	public function get_children():Array<Expression> {
		return [];
	}
}