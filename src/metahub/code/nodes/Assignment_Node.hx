package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Node_Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment_Node implements INode extends Standard_Node
{
	var is_immediate:Bool;

	public function new(group:Group, is_immediate:Bool)
	{
		super(group);
		add_ports(3);
		this.is_immediate = is_immediate;
	}

  override public function get_value(index:Int, context:Context):Change {
		if (group.only_new && !context.hub.is_node_new(context.node))
			return null;
		
		if (index == 0) {
			var change = ports[2].get_external_value(context);
			ports[1].set_external_value(change, context);
			return change;
		}

		if (index == 1) {
			return ports[2].get_external_value(context);
		}

		throw new Exception("Not supported.");
	}

	override public function to_string():String {
		return "assignment";
	}

  override public function set_value(index:Int, change:Change, context:Context, source:General_Port = null) {
		if (is_immediate)
			return;

		if (group.only_new && !context.hub.is_node_new(context.node))
			return null;
		
		//if (index == 1) // Temporary
			//throw new Exception("Not implemented.");

		var port = ports[index == 1 ? 2 : 1];
		//var new_context = port.resolve_external(context);
		//if (new_context != null)
			//port.set_external_value(value, new_context);

		port.set_external_value(change, context);

	}

}