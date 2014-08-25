package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Set_Weight implements Expression {
	var weight:Float;
	var statement:Expression;

	public function new(weight:Float, statement:Expression) {
		this.weight = weight;
		this.statement = statement;
	}

	public function get_type():Type_Signature {
		throw new Exception("Block.get_type() is not implemented.");
	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var new_group = new Group(group);
		new_group.weight = weight;
		return statement.to_port(scope, new_group, signature_node);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return statement.get_types();
	}

	public function to_string():String {
		return statement.to_string();
	}

	public function get_children():Array<Expression> {
		return statement.get_children();
	}
}