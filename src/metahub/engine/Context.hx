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
		if (entry_node == null)
			throw new Exception("Context node cannot be null.");

		this.node = entry_node;
		this.hub = hub;
	}

}