package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Group implements INode extends Standard_Node {
	public var nodes = new Array<INode>();

	public function new() {
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		//if (scope.definition.trellis == null) {
			//resolve(context);
		//}
		//else {
			//var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
			//for (node in nodes) {
				//var node_context = new Node_Context(node, scope.hub);
				//resolve(node_context);
			//}
		//}

		return null;
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		
	}

	override public function to_string():String {
		return "group";
	}

}