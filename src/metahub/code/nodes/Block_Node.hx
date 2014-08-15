package metahub.code.nodes;
import metahub.code.Scope;
import metahub.code.expressions.Block;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Expression_Utility;
import metahub.code.Type_Signature;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node_Context;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Block_Node implements INode {
	var ports = new Array<General_Port>();
	var scope:Scope;

	public function new(expressions:Array<Expression>, scope:Scope) {
		ports.push(new General_Port(this, 0));
		this.scope = scope;
		var type = new Type_Signature(Kind.unknown);
		for (expression in expressions) {
			var signature = Type_Network.analyze(expression, type, scope); 
			var port = expression.to_port(scope, null, signature);
			ports.push(port);
		}
	}

	public function get_port(index:Int):General_Port {
		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic{
		throw new Exception("Not implemented.");
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
		//block.resolve(scope);
	}

	public function run() {
		var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
		for (node in nodes) {
			var context = new Node_Context(node, scope.hub);
			resolve(context);			
		}
	}
	
	function resolve(context:Context):Dynamic {		
    for (i in 1...ports.length) {
			ports[i].get_node_value(context);
			//Expression_Utility.resolve(s, new Type_Signature(Kind.unknown), scope);
    }
    return null;
  }

}