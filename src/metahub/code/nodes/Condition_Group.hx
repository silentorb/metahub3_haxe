package metahub.code.nodes;
import metahub.code.functions.Comparison;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition_Group implements INode extends Standard_Node
{
	var join:Condition_Join;

	public function new(join:Condition_Join)
	{
		super();
		this.join = join;

		for (i in 0...2) {
			ports.push(new General_Port(this, i));
		}
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		if (join == Condition_Join.or) {
			return get_or(context);
		}
		else {
			return get_and(context);
		}
	}

	function get_and(context:Context):Bool {
		for (other in ports[1].connections)
		{
			var value:Bool = other.get_node_value(context);
			if (!value)
				return false;
		}

		return true;
	}

	function get_or(context:Context):Bool {
		for (other in ports[1].connections)
		{
			var value:Bool = other.get_node_value(context);
			if (value)
				return true;
		}

		return false;
	}

	override public function to_string():String {
		return Std.string(join);
	}
}