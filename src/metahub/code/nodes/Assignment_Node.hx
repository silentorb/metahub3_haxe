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
	//var trigger:General_Port;
	//var input:General_Port;
	//var output:General_Port;
//
	public function new(group:Group)
	{
		super(group);
		add_ports(3);
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

	}

}