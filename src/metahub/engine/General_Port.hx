package metahub.engine;

import metahub.code.nodes.INode;
import metahub.code.nodes.IResolution;
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

  public function get_node_value(context:Context):Dynamic {
		return node.get_value(id, context);
	}

	public function set_node_value(value:Dynamic, context:Context, source:General_Port) {
		node.set_value(id, value, context, source);
	}

	public function get_external_value(context:Context):Dynamic {
		if (connections.length > 1) {
			var result = new Array<Dynamic>();
			for (connection in connections) {
				result.push(connection.get_node_value(context));
			}

			return result;
		}

		if (connections.length == 0)
			throw new Exception("Cannot get_external_value from an unconnected port.");

		return connections[0].get_node_value(context);
	}

	public function set_external_value(value:Dynamic, context:Context) {
		for (connection in connections) {
			connection.set_node_value(value, context, this);
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
