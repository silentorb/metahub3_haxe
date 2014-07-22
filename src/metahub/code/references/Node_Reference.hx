package metahub.code.references;
import metahub.engine.INode;
import metahub.engine.IPort;
import metahub.engine.Node;
import metahub.code.symbols.Local_Symbol;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Node_Reference extends Reference<Local_Symbol> {

	override public function get_port(scope:Scope):IPort {
		throw new Exception("Not implemented yet.");
	}

	override public function resolve(scope:Scope):Dynamic {
		return get_node(scope);
	}

	function get_node(scope:Scope):INode {
		var id = symbol.resolve(scope);
		var node = scope.hub.nodes[id];
    var nodes = scope.hub.nodes;
    var length = chain.length - 1;
    for (i in 0...length) {
      var id = node.get_value(chain[i].id);
      node = nodes[id];
    }

    return node;
  }
}