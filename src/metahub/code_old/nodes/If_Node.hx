package metahub.code.nodes;
import metahub.code.nodes.INode;
import metahub.engine.Context;
import metahub.code.nodes.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class If_Node implements INode extends Standard_Node
{
	public function new(group:Group)
	{
		super(group);
		for (i in 0...3) {
			ports.push(new General_Port(this, i));
		}
	}

  override public function get_value(index:Int, context:Context):Change {
		var change = ports[1].get_external_value(context);
		if (change == null)
			return null;
			
		var condition_result:Bool = change.value;
		ports[1].get_external_value(context);
		if (condition_result)
			return ports[2].get_external_value(context);

		return null;
	}

	override public function to_string():String {
		return "if";
	}
}