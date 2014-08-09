package metahub.code.nodes;
import metahub.engine.Context;
import metahub.code.Path;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Path_Condition implements INode {
	var ports = new Array<General_Port>();
	var trellis:Trellis;
	var path:Path;

	public function new(path:Path, trellis:Trellis) {
		this.path = path;
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
		if (index == 1)
			throw new Exception("Not implemented");

		var reversed = path.reverse();
		var node_id = reversed.resolve(context.node);
		if (node_id == null || node_id == 0)
			return null;

		var node = context.hub.get_node(node_id);
		if (!node.trellis.is_a(trellis))
			return;

		ports[index - 1].set_external_value(value, context);
	}
}