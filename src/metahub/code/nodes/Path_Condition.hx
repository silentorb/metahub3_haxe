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
class Path_Condition implements INode {
	var ports = new Array<General_Port>();
	var trellis:Trellis;
	var path:Path;
	var reverse_path:Path;

	public function new(path:Path, trellis:Trellis) {
		this.path = path;
		this.reverse_path = path.reverse();
		this.trellis = trellis;
		ports.push(new General_Port(this, 0));
		ports.push(new General_Port(this, 1));
	}

	public function get_port(index:Int):General_Port {
		#if debug
		if (index <0 || index > 1)
			throw new Exception("Invalid port id: " + index);
		#end

		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic {
		throw new Exception("Not implemented");
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (index == 1) {
			ports[1 - index].set_external_value(value, context);
			return;
		}
			//throw new Exception("Not implemented");

		var node:Node = reverse_path.resolve(context.node);
		if (node == null)
			return;

		//var node = context.hub.get_node(node_id);
		if (!node.trellis.is_a(trellis))
			return;

		ports[1 - index].set_external_value(value, context);
	}
}