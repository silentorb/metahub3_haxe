package metahub.code.nodes;
import metahub.engine.Context;
import metahub.code.Path;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Path_Condition extends Standard_Node {
	var trellis:Trellis;
	var path:Path;
	var reverse_path:Path;

	public function new(path:Path, trellis:Trellis, group:Group) {
		super(group);
		this.path = path;
		this.reverse_path = path.reverse();
		this.trellis = trellis;
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		if (index == 1)
			return ports[1 - index].get_external_value(context);

		throw new Exception("Not implemented");
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (index == 1) {
			ports[1 - index].set_external_value(value, context);
			return;
		}

		var node:Node = reverse_path.resolve(context.node);
		if (node == null)
			return;

		//var node = context.hub.get_node(node_id);
		if (!node.trellis.is_a(trellis))
			return;

		ports[1 - index].set_external_value(value, context);
	}

	override public function to_string():String {
		return "path condition: " + path.to_string();
	}
}