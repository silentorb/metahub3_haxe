package metahub.engine;
import metahub.Hub;
import metahub.schema.Property;
import metahub.schema.Property_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Context {
	public var node:Node;
	public var hub:Hub;

	public function new(entry_node:Node, hub:Hub) {
		this.node = entry_node;
		this.hub = hub;
	}

}