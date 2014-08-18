package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Group implements INode {
	public var nodes = new Array<INode>();

	public function new() {

	}

	public function get_port(index:Int):General_Port {
		//return ports[index];
		throw new Exception("Not implemented.");
	}

  public function get_value(index:Int, context:Context):Dynamic {
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

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
		//block.resolve(scope);
	}

}