package metahub.code.nodes;
import metahub.code.Path;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Symbol_Node extends Standard_Node {
	var node:Node;
	var path:Path;

	public function new(node:Node, path:Path, group:Group) {
		super(group);
		this.node = node;
		this.path = path;
		add_ports(1);
	}

  override public function get_value(index:Int, context:Context):Dynamic{
		return path.resolve(node);
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (path.length == 0)
			throw new Exception("Not implemented yet.");

		var parent:Node = path.resolve(node, -1);
		parent.set_value(path.last().id, value, source);
	}

	override public function to_string():String {
		var result = "@" + node.trellis.name;
		if (path.length > 0)
			result += "." + path.to_string();

		return result;
	}
}