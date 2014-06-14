package engine;
import schema.Property;
import schema.Property_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Context {
	public var property_port:Property_Port;
	public var entry_node:INode;

	public function new(property_port:Property_Port, entry_node:INode) {
		this.property_port = property_port;
		this.entry_node = entry_node;
	}

}