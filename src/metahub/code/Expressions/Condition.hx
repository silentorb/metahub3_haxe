package metahub.code.expressions;
import metahub.code.Condition_Join;
import metahub.code.functions.Functions;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition implements Expression
{
	var first:Expression;
	var second:Expression;
	var operator:Functions;
	
	public function new(first:Expression, second:Expression, operator:Functions) 
	{
		this.first = first;
		this.second = second;
		this.operator = operator;
	}
	  
	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_types():Array<Array<Type_Signature>>{
		return [  ];
	}

	public function to_string():String {
		return "condition";
	}

	public function get_children():Array<Expression> {
		return [];
	}
}