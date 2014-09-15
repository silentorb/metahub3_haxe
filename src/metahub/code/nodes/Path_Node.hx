package metahub.code.nodes;
import metahub.engine.Context;
import metahub.code.Path;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Node;
import metahub.engine.Node_Context;
import metahub.schema.Property;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Path_Node extends Standard_Node {
	//var reverse_path:Path;

	public function new(group:Group) {
		super(group);
		//this.reverse_path = path.reverse();
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		//throw new Exception("Not implemented");
		//if (index == 1)

		//ports[1 - index].get_external_value(context);
		return _resolve(context);
		//return get_last_token_port().get_node_value(new Node_Context(node, context.hub));
	}

	function get_last_token_port() {
		var connections = ports[1].connections;
		return connections[connections.length - 1];
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (index == 1) {
			var token_index = get_index(source);
			var root_context = get_root(context, token_index);
			if (root_context == null)
				return;

			var expression_value = _resolve(root_context);
			ports[0].set_external_value(expression_value, root_context);
			return;
		}

		var previous = _resolve(context, -1);
		if (previous != null) {
			var connections = ports[1].connections;
			var token:IToken_Node = cast get_last_token_port().node;
			token.set_token_value(value, previous, context);
		}
	}

	function get_index(other_port:General_Port) {
		var i = 0;
		for (connection in ports[1].connections) {
			if (connection == other_port)
				return i;

			++i;
		}

		throw new Exception("Could not find local port index.");
	}

	function get_root(context:Context, token_index:Int) {
		var value:Dynamic = context.node;
		var connections = ports[1].connections;
		var i = token_index;
		while (--i >= 0) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			var previous = i > 0 ? connections[i - 1].node : null;
			value = token.resolve_token_reverse(value, previous);
			if (value == null)
				return null;
		}

		return new Node_Context(value, context.hub);
	}

	override public function to_string():String {
		return "Path";
	}

	function _resolve(context:Context, end_offset:Int = 0):Dynamic {
		var value = context.node;
		var connections = ports[1].connections;
		for (i in 0...(connections.length + end_offset)) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			value = token.resolve_token(value);
			if (value == null)
				return null;
		}

		//return connections[connections.length - 1];
		return value;
	}

	override function resolve(context:Context):Context {
		var node = _resolve(context, -1);
		if (node == null)
			return null;

		return new Node_Context(node, context.hub);
		//return result != null ? result : new Empty_Resolution();
	}
}