package metahub.engine;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Port
{
	public var connections = new Array<Port>();
	public var node:Node;
	public var id:Int;

	public function new(node:Node, id:Int) {
		this.node = node;
		this.id = id;
	}
	
	public function connect(port:Port) {
		if (connections.indexOf(port) > -1)
			return;
			
		connections.push(port);
		port.connections.push(this);
	}
	
}