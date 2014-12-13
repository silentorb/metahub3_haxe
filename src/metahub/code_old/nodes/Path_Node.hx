package metahub.code.nodes;
import metahub.code.Change;
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
	var trellis:Trellis;
	//var reverse_path:Path;

	public function new(group:Group, trellis:Trellis) {
		super(group);
		this.trellis = trellis;
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Change {
		return _resolve(context);
	}

	function get_last_token_port() {
		var connections = ports[1].connections;
		return connections[connections.length - 1];
	}

  override public function set_value(index:Int, change:Change, context:Context, source:General_Port = null) {
		if (index == 1) {
			var token_index = get_index(source);
			var root_context = get_root(context, token_index);
			if (root_context == null)
				return;

			var resolution = _resolve(root_context);
			if (resolution == null)
				return;
				
			ports[0].set_external_value(resolution, root_context);
		}
		else {
			var previous = _resolve(context, -1);
			if (previous != null) {
				var connections = ports[1].connections;
				var token:IToken_Node = cast get_last_token_port().node;
				var new_context = Reflect.hasField(previous.value, 'trellis')
					? new Node_Context(previous.value, context.hub)
					: context;

				token.set_token_value(change.value, previous.value, new_context);
			}
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

	function get_root(context:Context, token_index:Int):Context {
		var value:Dynamic = context.node;
		var connections = ports[1].connections;
		var i = token_index;
		while (--i >= 0) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			var previous = i > 0 ? connections[i - 1].node : null;
			var resolution = token.resolve_token_reverse(value, previous);
			if (resolution == null)
				return null;

			value = resolution.value;
		}

		var node:Node = cast value;
		if (!node.trellis.is_a(trellis))
			return null;

		return new Node_Context(value, context.hub);
	}

	override public function to_string():String {
		return "Path";
	}

	function _resolve(context:Context, end_offset:Int = 0):Change {
		var value = context.node;
		var connections = ports[1].connections;
		for (i in 0...(connections.length + end_offset)) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			var is_last = i == connections.length - 1;
			var resolution = token.resolve_token(value, is_last);
			if (resolution == null || is_last)
				return resolution;

			value = resolution.value;
			if (value == null)
				return null;
		}

		// Can only get here if the iteration count is zero.
		return new Change(value);
	}

	override function resolve(context:Context):Context {
		var resolution = _resolve(context, -1);
		if (resolution == null)
			return null;

		return new Node_Context(resolution.value, context.hub);
		//return result != null ? result : new Empty_Resolution();
	}
}