package metahub.code.expressions;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Block_Node;
import metahub.code.Type_Signature;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Block implements Expression {

  var node:Block_Node;
	var expressions = new Array<Expression>();
	
	public function new() {
		
	}

	public function add(expression:Expression) {
		expressions.push(expression);
	}

  //public function resolve(scope:Scope):Dynamic {			
    //for (s in expressions) {
			//Expression_Utility.resolve(s, new Type_Signature(Kind.unknown), scope);
      ////s.resolve(scope);
    //}
    //return null;
  //}

	public function get_type():Type_Signature {
		throw new Exception("Block.get_type() is not implemented.");
	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var node = new Block_Node(expressions, scope);
		return node.get_port(0);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ new Type_Signature(Kind.any)] ];
	}

	public function to_string():String {
		return "Block";
	}

	public function get_children():Array<Expression> {
		return [];
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		throw new Exception("Not implemented.");
	}
}