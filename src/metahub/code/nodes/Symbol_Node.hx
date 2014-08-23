package metahub.code.nodes;
import metahub.code.Path;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Symbol_Node implements INode{
	var port:General_Port;
	var node:Node;
	var path:Path;

	public function new(node:Node, path:Path) {
		this.node = node;
		this.path = path;
		port = new General_Port(this, 0);
	}

	public function get_port(index:Int):General_Port {
		return port;
	}
	
	public function get_port_count():Int {
		return 1;
	}
	
  public function get_value(index:Int, context:Context):Dynamic{
		return path.resolve(node);
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (path.length == 0)
			throw new Exception("Not implemented yet.");
			
		var parent:Node = path.resolve(node, -1);
		parent.set_value(path.last().id, value, source);
	}

	public function to_string():String {
		var result = "@" + node.trellis.name;
		if (path.length > 0)
			result += "." + path.to_string();
			
		return result;
	}
}