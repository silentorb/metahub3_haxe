package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node_Context;
import metahub.Hub;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Create_Node implements INode
{
	var block_port:General_Port;
	var output:General_Port;
	var trellis:Trellis;
	var hub:Hub;
	
	public function new(trellis:Trellis, hub:Hub, block_port:General_Port) 
	{
		this.trellis = trellis;
		this.hub = hub;
		output = new General_Port(this, 0);
		this.block_port = block_port;
	}
		
	public function get_port(index:Int):General_Port {
		return output;
	}
	
	public function get_port_count():Int {
		return 1;
	}

  public function get_value(index:Int, context:Context):Dynamic {
    var node = hub.create_node(trellis);
		if (block_port != null) {
			var node_context = new Node_Context(node, hub);
			block_port.get_node_value(node_context);
		}
		return node;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented");
	}		
	
	public function to_string():String {
		return "new " + trellis.name;
	}
}