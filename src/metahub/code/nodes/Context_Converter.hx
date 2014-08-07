package metahub.code.nodes;
import metahub.code.Path;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;
import metahub.engine.Node_Context;
import metahub.schema.Kind;
import metahub.schema.Property;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Context_Converter implements INode {
	public var ports = new Array<General_Port>();
	public var properties = new Array<Property>();
	public var path:Path;

	public function new(path:Path) {
		this.path = path;
		properties.push(path.first());
		properties.push(path.last());

		ports.push(new General_Port(this, 0));
		ports.push(new General_Port(this, 1));
	}

	function create_context(context:Context, node_id:Int) {
		var node = context.hub.get_node(node_id);
		return new Node_Context(node, context.hub);
	}

	public function get_port(index:Int):General_Port {
		#if debug
		if (index <0 || index > 1)
			throw new Exception("Invalid port id: " + index);
		#end

		return ports[index];
	}

	public function get_value(index:Int, context:Context):Dynamic {
		//index = 1 - index;
		var port = ports[1 - index];
		var property = properties[index];
		if (property.type == Kind.list) {
			var list:Array<Dynamic> = cast context.node.get_value(property.id);
			return Lambda.array(Lambda.map(list, function(node_id) {
				if (node_id == 0)
					throw new Exception("Context_Converter cannot get value for null reference.");

				return port.get_external_value(create_context(context, node_id));
			}));
		}
		else {
			trace("get - Converting " + property.fullname() + " to " + property.other_property.fullname());
			var node_id:Int = cast context.node.get_value(property.id);
			if (node_id == 0)
				throw new Exception("Context_Converter cannot get value for null reference.");

			return port.get_external_value(create_context(context, node_id));
		}
	}

	public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		//index = 1 - index;
		var port = ports[1 - index];
		var property = properties[index];
		trace("set - Converting " + property.fullname() + " to " + property.other_property.fullname());
		if (property.type == Kind.list) {
			var ids:Array<Int> = cast context.node.get_value(property.id);
			for (i in ids) {
				if (i > 0)
					port.set_external_value(value, create_context(context, i));
			}
		}
		else {
			var node_id:Int = cast context.node.get_value(property.id);
			if (node_id > 0)
				port.set_external_value(value, create_context(context, node_id));
		}
	}
}