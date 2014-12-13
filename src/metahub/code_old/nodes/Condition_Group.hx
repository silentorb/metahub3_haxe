package metahub.code.nodes;
import metahub.code.Change;
import metahub.code.functions.Comparison;
import metahub.engine.Context;
import metahub.code.nodes.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition_Group implements INode extends Standard_Node
{
	var join:Condition_Join;

	public function new(join:Condition_Join, group:Group)
	{
		super(group);
		this.join = join;

		for (i in 0...2) {
			ports.push(new General_Port(this, i));
		}
	}

  override public function get_value(index:Int, context:Context):Change {
		return join == Condition_Join.or
			? get_or(context)
			: get_and(context)
			;
	}

	function get_and(context:Context):Change {
		for (other in ports[1].connections)
		{
			var change = other.get_node_value(context);
			if (change == null)
				return null;
			
			var value:Bool = change.value;
			if (!value)
				return new Change(false);
		}

		return new Change(true);
	}

	function get_or(context:Context):Change {
		for (other in ports[1].connections)
		{
			var change = other.get_node_value(context);
			if (change == null)
				return null;
				
			var value:Bool = change.value;
			if (value)
				return new Change(true);
		}

		return new Change(false);
	}

	override public function to_string():String {
		return Std.string(join);
	}
}