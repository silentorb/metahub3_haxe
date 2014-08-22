package metahub.code.nodes;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Standard_Node
{
	var ports = new Array<General_Port>();

	public function get_port_count():Int {
		return ports.length;
	}
	
	public function get_port(index:Int):General_Port {
		return ports[index];
	}

}