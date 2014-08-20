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
    return null;
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