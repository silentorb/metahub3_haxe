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
	public var children:Array<Expression>;

	public function new(weight:Float, statement:Expression) {
		this.weight = weight;
		this.statement = statement;
		children = [ statement ];
	}

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		return null;
	}

  public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var new_group = new Group(group);
		new_group.weight = weight;
		return statement.to_port(scope, new_group, signature_node);
  }

	public function to_string():String {
		return statement.to_string();
	}

	public function get_children():Array<Expression> {
		return statement.children;
	}
}