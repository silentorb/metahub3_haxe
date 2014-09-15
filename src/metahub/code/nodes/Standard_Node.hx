package metahub.code.nodes;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Standard_Node implements INode
{
	var ports = new Array<General_Port>();
	public var group:Group;
	var id:Int;
	static var id_counter = 0;

	function new(group:Group) {
		this.group = group;
		id = id_counter++;
	}

	public function get_port_count():Int {
		return ports.length;
	}

	public function get_port(index:Int):General_Port {
		return ports[index];
	}

	public function add_ports(count:Int) {
		for (i in 0...count) {
			ports.push(new General_Port(this, ports.length));
		}
	}

	public function get_value(index:Int, context:Context):Dynamic {
		throw new Exception("Not implemented");
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented");
	}

	public function to_string():String {
		throw new Exception("Not implemented");
	}

	public function resolve(context:Context):Context {
		//throw new Exception("Not implemented.");
		return context;
	}

}