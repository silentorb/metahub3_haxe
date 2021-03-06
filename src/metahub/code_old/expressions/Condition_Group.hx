package metahub.code.expressions;
import metahub.code.Condition_Join;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition_Group implements Expression
{
	public var children:Array<Expression>;
	var join:Condition_Join;
	//public var children = new Array<Expression>();

	public function new(conditions:Array<Expression>, join:Condition_Join)
	{
		this.children = conditions;
		this.join = join;
	}

	public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
    var node = new metahub.code.nodes.Condition_Group(join, group);
		var input = node.get_port(1);
		for (condition in children) {
			input.connect(condition.to_port(scope, group, signature_node));
		}
		return node.get_port(0);
  }

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		return [ new Type_Signature(Kind.bool) ];
		//var list = [ new Type_Signature(Kind.bool) ];
		//for (condition in children) {
			//list.push(list[0]);
		//}
		//return list;
	}

	public function to_string():String {
		return Std.string(join);
	}

	public function get_children():Array<Expression> {
		return children;
	}
}