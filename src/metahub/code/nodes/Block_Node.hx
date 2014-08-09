package metahub.code.nodes;
import metahub.code.Scope;
import metahub.code.Setter;
import metahub.code.statements.Block;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Block_Node implements INode {

	var port:General_Port;
	var block:Block;
	var scope:Scope;

	public function new(block:Block, scope:Scope) {
		port = new General_Port(this, 0);
		this.block = block;
		this.scope = scope;
	}

	public function get_port(index:Int):General_Port {
		return port;
	}

  public function get_value(index:Int, context:Context):Dynamic{
		throw new Exception("Not implemented.");
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		block.resolve(scope);
	}

	public function run() {
		var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
		for (node in nodes) {
			var node_scope = new Scope(scope.hub, scope.definition, scope.parent);
			node_scope.node = node;
			block.resolve(node_scope);
		}
	}

}