package metahub.engine;

import metahub.code.Change;
import metahub.code.nodes.INode;
import metahub.schema.Kind;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.functions.Functions;
import metahub.engine.Relationship;

/**
 * ...
 * @author Christopher W. Johnson
 */

class General_Port {
	public var connections = new Array<General_Port>();
	public var node:INode;
	public var id:Int;

	public function new(node:INode, id:Int) {
		this.node = node;
		this.id = id;
	}

	public function connect(port:General_Port) {
		if (connections.indexOf(port) > -1)
			return;

		connections.push(port);
		port.connections.push(this);
	}

  public function get_node_value(context:Context):Change {
		return node.get_value(id, context);
	}

	public function set_node_value(change:Change, context:Context, source:General_Port) {
		node.set_value(id, change, context, source);
	}

	public function get_external_value(context:Context):Change {
		if (connections.length > 1) {
			var result = new Array<Dynamic>();
			for (connection in connections) {
				var change = connection.get_node_value(context);
				if (change != null)
					result.push(change.value);
			}

			return new Change(result);
		}

		if (connections.length == 0)
			return null;
			//throw new Exception("Cannot get_external_value from an unconnected port.");

		return connections[0].get_node_value(context);
	}

	public function set_external_value(change:Change, context:Context) {
		for (connection in connections) {
			connection.set_node_value(change, context, this);
		}
	}

	public function resolve_node(context:Context):Context {
		return node.resolve(context);
	}

	public function resolve_external(context:Context):Context {
		if (connections.length > 1) {
			throw new Exception("Resolving multiple connections not yet supported.");
		}

		if (connections.length == 0)
			throw new Exception("Cannot get_external_value from an unconnected port.");

		return connections[0].node.resolve(context);
	}
}
