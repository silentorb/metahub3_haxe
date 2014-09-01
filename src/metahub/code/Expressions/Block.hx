package metahub.code.expressions;
import metahub.code.nodes.Block_Node;
import metahub.code.Type_Signature;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;
import metahub.code.nodes.Group;

class Block implements Expression {

  var node:Block_Node;
	public var children = new Array<Expression>();

	public function new() {

	}

	public function add(expression:Expression) {
		children.push(expression);
	}

	public function get_type():Type_Signature {
		throw new Exception("Block.get_type() is not implemented.");
	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var node = new Block_Node(scope, group);
		for (expression in children) {
			var signature = Type_Network.analyze(expression, scope);
			var port = expression.to_port(scope, group, signature);
			if (port != null) {
				if (Type.getClassName(Type.getClass(expression)) != "metahub.code.children.Trellis_Scope")
					node.get_port(1).connect(port);
				else
					node.get_port(2).connect(port);
			}
			else {
				throw new Exception("Null port!");
			}
		}

		return node.get_port(0);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return null;
	}

	public function to_string():String {
		return "Block";
	}

	public function get_children():Array<Expression> {
		return return children;
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		throw new Exception("Not implemented.");
	}
}