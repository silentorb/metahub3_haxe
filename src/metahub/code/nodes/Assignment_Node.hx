package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node_Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment_Node implements INode
{
	var trigger:General_Port;
	var input:General_Port;
	var output:General_Port;

	public function new(output:General_Port, input:General_Port) 
	{
		trigger = new General_Port(this, 0);
		this.output = output;
		this.input = input;
	}
	
	public function get_port(index:Int):General_Port {
		return trigger;
	}

  public function get_value(index:Int, context:Context):Dynamic {
		var value = input.get_node_value(context);
		output.set_node_value(value, context, null);
		return value;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented");
	}
}