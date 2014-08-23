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

class Block_Node implements INode extends Standard_Node {
	var scope:Scope;

	public function new(expressions:Array<Expression>, scope:Scope) {
		for (i in 0...3) {
		ports.push(new General_Port(this, i));
		}
		this.scope = scope;
		var type = new Type_Signature(Kind.unknown);
		for (expression in expressions) {
			var signature = Type_Network.analyze(expression, type, scope);
			var port = expression.to_port(scope, null, signature);
			if (port != null) {
				if (Type.getClassName(Type.getClass(expression)) != "metahub.code.expressions.Trellis_Scope")
					ports[1].connect(port);
				else
					ports[2].connect(port);
			}
			else {
				throw new Exception("Null port!");
			}
		}
	}

  public function get_value(index:Int, context:Context):Dynamic {
		if (scope.definition.trellis == null) {
			resolve(context);
		}
		else {
			var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
			for (node in nodes) {
				var node_context = new Node_Context(node, scope.hub);
				resolve(node_context);
			}
		}

		return null;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		//throw new Exception("Not implemented.");
	}

	public function run() {
		var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
		for (node in nodes) {
			var context = new Node_Context(node, scope.hub);
			resolve(context);
		}
	}

	function resolve(context:Context):Dynamic {
		if (ports[1].connections.length > 0)
			ports[1].get_external_value(context);
			
    //for (i in 1...ports.length) {
			//ports[i].get_node_value(context);
    //}
    return null;
  }
	
	public function to_string():String {
		if (scope.definition.trellis != null)
			return "block " + scope.definition.trellis.name;
			
		return "block";
	}
}