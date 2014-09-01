package metahub.code.nodes;
import metahub.code.Path;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;
import metahub.engine.Node;
import metahub.engine.Node_Context;
import metahub.schema.Kind;
import metahub.schema.Property;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Context_Converter extends Standard_Node {
	var forward_path:Path;
	var reverse_path:Path;
	var trellis:Trellis;

	public function new(path:Path, trellis:Trellis, group:Group) {
		super(group);
		this.trellis = trellis;
		forward_path = path.slice(0, -1);
		reverse_path = create_reverse(path);
		add_ports(2);
	}

	static function create_reverse(path:Path):Path {
		var reverse = new Array<Property>();
		var i = path.length - 1;
		while (--i >= 0) {
			var property = path.at(i);
			if (property.other_property == null)
				throw new Exception(property.fullname() + " is missing a backreference.");

			reverse.push(property.other_property);
		}
		return new Path(reverse);
	}

	static function has_lists(path:Path) {
		for (i in 0...path.length) {
			if (path.at(i).type == Kind.list)
				return true;
		}

		return false;
	}

	override public function get_value(index:Int, context:Context):Dynamic {
		//throw new Exception("Not implemented.");
		var port = ports[1 - index];

		var current_path = index == 0 ? forward_path : reverse_path;
		if (has_lists(current_path))
			throw new Exception("Not implemented.");

		var nodes = follow_path(current_path, 0, context.node, index);
		var property_id = current_path.last().id;

		if (nodes.length == 0)
			return null;
			//throw new Exception("Context_Converter cannot get value for null reference.");

		return port.get_external_value(new Node_Context(nodes[0], context.hub));

		//for (node in nodes) {
			//port.set_external_value(value, new Node_Context(node, context.hub));
		//}

		/*var port = ports[1 - index];
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
		}*/
	}

	override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		var port = ports[1 - index];

		var current_path = index == 0 ? forward_path : reverse_path;
		var nodes = follow_path(current_path, 0, context.node, index);
		var property_id = current_path.last().id;
		for (node in nodes) {
			port.set_external_value(value, new Node_Context(node, context.hub));
			//node.set_value(property_id, value);
		}
	}

	function follow_path(path:Path, step:Int, node:Node, dir:Int):Array<Node>{
		var property = path.at(step);
		var result = new Array<Node>();

		if (step < path.length - 1) {
			if (property.type == Kind.list) {
				var ids:Array<Node> = cast node.get_value(property.id);
				for (i in ids) {
					if (i != null)
						result = result.concat(follow_path(path, ++step, i, dir));
				}
			}
			else {
				var node_id:Node = node.get_value(property.id);
				if (node_id != null)
					result = result.concat(follow_path(path, ++step, node_id, dir));
			}
		}
		else {
			if (property.type == Kind.list) {
				var ids:Array<Node> = node.get_value(property.id);
				for (node in ids) {
					if (node != null) {
						if (node.trellis.is_a(trellis))
							result.push(node);
					}
				}
			}
			else {
				var node:Node = node.get_value(property.id);
				if (node != null) {
					if (dir == 0 || node.trellis.is_a(trellis))
							result.push(node);
				}
					//port.set_external_value(value, create_context(node.hub, node_id));
			}
		}

		return result;
	}

	override public function to_string():String {
		return "context converter";
	}
}