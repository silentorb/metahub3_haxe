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
class Create_Node implements INode extends Standard_Node
{
	//var block_port:General_Port;
	//var output:General_Port;
	var trellis:Trellis;
	var hub:Hub;

	public function new(trellis:Trellis, hub:Hub, group:Group)
	{
		super(group);
		add_ports(2);
		this.trellis = trellis;
		this.hub = hub;
	}

  override public function get_value(index:Int, context:Context):Dynamic {
    var node = hub.create_node(trellis);
		if (ports[1].connections.length > 0) {
			var node_context = new Node_Context(node, hub);
			ports[1].get_external_value(node_context);
		}
		return node;
	}

	override public function to_string():String {
		return "new " + trellis.name;
	}
}