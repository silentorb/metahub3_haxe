package metahub.code.nodes;
import metahub.engine.Context;
import metahub.code.Path;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.schema.Property;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Path_Node extends Standard_Node {
	var property:Property;
	//var reverse_path:Path;

	public function new(property:Property, group:Group) {
		super(group);
		this.property = property;
		//this.reverse_path = path.reverse();
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		throw new Exception("Not implemented");
		//if (index == 1)
			//return ports[1 - index].get_external_value(context);

	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		//throw new Exception("Not implemented.");
		//if (index == 1) {
			//ports[1 - index].set_external_value(value, context);
			//return;
		//}
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
}