package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
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

  override public function get_value(index:Int, context:Context):Dynamic {
		var value = ports[2].get_external_value(context);
		ports[1].set_external_value(value, context);
		return value;
	}

	override public function to_string():String {
		//return output.node.to_string() + " = " + input.node.to_string();
		return "assignment";
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (is_immediate)
			return;

		var port = ports[index == 1 ? 2 : 1];
		port.set_external_value(value, context);
	}

}