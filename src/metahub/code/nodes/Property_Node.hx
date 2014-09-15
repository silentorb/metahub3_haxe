package metahub.code.nodes;
import metahub.engine.Context;
import metahub.code.Path;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Node;
import metahub.engine.Node_Context;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Property_Node extends Standard_Node implements IToken_Node {
	public var property:Property;

	// If set to true, this node is only used to support a larger path expression that
	// will never modify the property referenced by this node.
	public var read_only:Bool;

	public function new(property:Property, group:Group, read_only:Bool) {
		super(group);
		this.property = property;
		this.read_only = read_only;
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		//throw new Exception("Not implemented");
		return ports[1 - index].get_external_value(context);

		//if (index == 1)
			//return ports[1 - index].get_external_value(context);

	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (index == 1) {
			ports[0].set_external_value(value, context);
			return;
		}

		if (index == 0) {
			ports[1].set_external_value(value, context);
			return;
		}

		throw new Exception("Invalid Port: " + index);
//
		//var node:Node = reverse_path.resolve(context.node);
		//if (node == null)
			//return;
//
		////var node = context.hub.get_node(node_id);
		//if (!node.trellis.is_a(trellis))
			//return;
//
		//ports[1 - index].set_external_value(value, context);
	}

	override public function to_string():String {
		return "path: " + property.fullname();
	}
//
	//override function resolve(context:Context):IResolution {
		//return new Resolution(context, ports[1].connections[0].node);
	//}

  public function resolve_token(node:Dynamic):Dynamic {
		if (!node.trellis.is_a(property.trellis))
			throw new Exception("Trellis mixup!");
		//if (property.other_trellis != null) {

			var value = node.get_value(property.id);
			return value;
			//if (value == null)
				//return null;

			//if (property.type == Kind.list) {
				//var list:Array<Dynamic> = value;
				//return list[0];
			//}
//
			//var single_value:Dynamic = cast value;
			//return new Node_Context(single_value, node.hub);
		//}

		throw new Exception("Not supported.");

		//return node;
	}

	public function resolve_token_reverse(node:Dynamic, previous:Dynamic):Dynamic {
		if (property.other_property != null) {
			var other = property.other_property;
			if (!node.trellis.is_a(other.trellis))
				throw new Exception("Path resolution trellis mixup!");

			var value = node.get_value(other.id);
			if (value == null)
				return null;

			if (other.type == Kind.list) {
				var list:Array<Dynamic> = value;
				return list.length > 0 ? list[0] : null;
			}

			return value;
		}
		else if (property.other_trellis != null && property.other_trellis.is_value) {
			var node = node.get_value(property.other_trellis.properties.length - 1);
			if (node == null || !node.trellis.is_a(property.other_trellis))
				return null;

			return node;
		}
		throw new Exception("Not supported.");
	}

	public function set_token_value(value:Dynamic, previous:Dynamic, context:Context) {
		ports[1].set_external_value(value, context);
	}
}