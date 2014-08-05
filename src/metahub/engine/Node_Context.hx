package metahub.engine;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Node_Context extends Context
{

	public function new(entry_node:Node, hub:Hub) {
		if (entry_node == null)
			throw new Exception("Context node cannot be null.");

		this.node = entry_node;
		this.hub = hub;
	}

}