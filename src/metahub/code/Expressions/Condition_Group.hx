package metahub.code.expressions;
import metahub.code.Condition_Join;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition_Group implements Expression
{
	var conditions:Array<Expression>;
	var join:Condition_Join;
	
	public function new(conditions:Array<Expression>, join:Condition_Join) 
	{
		this.conditions = conditions;
		this.join = join;
	}
	  
	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    var node = new metahub.code.nodes.Condition_Group(join);
		var input = node.get_port(1);
		for (condition in conditions) {
			input.connect(condition.to_port(scope, group, signature_node));
		}
		return node.get_port(0);
  }

	public function get_types():Array<Array<Type_Signature>>{
		return [  ];
	}

	public function to_string():String {
		return Std.string(join);
	}

	public function get_children():Array<Expression> {
		return [];
	}
}