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

		var resolution = _resolve(context);
		return resolution.node.get_value(0, resolution.context);
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (index == 1) {
			var token_index = get_index(source);
			if (!is_source_in_path(context, token_index))
				return;

			ports[0].set_external_value(value, context);
			return;
		}

		var resolution = resolve(context);
		resolution.run(value);
	}

	function get_index(other_port:General_Port) {
		for (connection in other_port.connections) {
			if (connection.node == this)
				return connection.id;
		}

		throw new Exception("Could not find local port index.");
	}

	function is_source_in_path(context:Context, token_index:Int):Bool {
		var value:Dynamic = context.node;
		var connections = ports[1].connections;
		var i = connections.length - 1;
		while (--i > 0) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			var previous = i > 0 ? connections[i - 1].node : null;
			value = token.resolve_token_reverse(value, previous);
			if (value == null)
				return false;
		}

		return true;
	}

	override public function to_string():String {
		return "Path";
	}

	function _resolve(context:Context):Resolution {
		var value = context.node;
		var connections = ports[1].connections;
		for (i in 0...(connections.length - 1)) {
			var port = connections[i];
			var token:IToken_Node = cast port.node;
			value = token.resolve_token(value);
			if (value == null)
				return null;
		}

		return new Resolution(new Node_Context(value, context.hub), connections[connections.length - 1].node);
	}

	override function resolve(context:Context):IResolution {
		var result = _resolve(context);
		return result != null ? result : new Empty_Resolution();
	}
}