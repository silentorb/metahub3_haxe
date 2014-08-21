package metahub.code.expressions;
import metahub.code.Condition_Join;
import metahub.code.functions.Comparison;
import metahub.code.functions.Functions;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;
import metahub.schema.Kind;

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
		var types = first.get_types();
		var type = types[0][0].type;
		var comparison_class = Type.resolveClass(get_comparison_class(type));
		var comparison:Comparison = Type.createInstance(comparison_class, [type]);
		
    var node = new metahub.code.nodes.Condition(comparison);
		first.to_port(scope, group, signature_node).connect(node.get_port(1));
		second.to_port(scope, group, signature_node).connect(node.get_port(2));
		
		return node.get_port(0);
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
	
	public static function get_comparison_class(type:Kind) {
		switch (type) 
		{
			case Kind.float:
				return "metahub.code.functions.Function_Library";
			default:
				throw new Exception("Could not find comparison for type: " + Std.string(type) + ".");
		}
	}
}