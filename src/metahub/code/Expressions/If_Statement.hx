package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.code.nodes.If_Node;
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
    var node = new If_Node();
		node.get_port(1).connect(condition.to_port(scope, group, signature_node));
		node.get_port(2).connect(expression.to_port(scope, group, signature_node));
		return node.get_port(0);
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