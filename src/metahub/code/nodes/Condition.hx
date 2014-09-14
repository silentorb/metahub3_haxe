package metahub.code.nodes;
import metahub.code.functions.Comparison;
import metahub.engine.Context;
import metahub.code.nodes.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition implements INode extends Standard_Node
{
	var comparison:Comparison;

	public function new(comparison:Comparison, group:Group)
	{
		super(group);
		this.comparison = comparison;

		for (i in 0...3) {
			ports.push(new General_Port(this, i));
		}
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		var first = ports[1].get_external_value(context);
		var second = ports[2].get_external_value(context);
		return comparison.compare(first, second);
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		// Right now only incremental conditions are supported, so this set_value should by empty.
		// Once event-driven conditions are also supported, this should check which type of condition
		// it is and either do nothing or update it's dependents.

	}

	override public function to_string():String {
		return comparison.to_string();
	}
}