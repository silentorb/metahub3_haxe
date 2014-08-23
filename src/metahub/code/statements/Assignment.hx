package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Group;
//import metahub.code.expressions.Expression_Utility;
import metahub.code.functions.Functions;
import metahub.code.nodes.Assignment_Node;
import metahub.code.Reference;
import metahub.code.Type_Signature;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.Node_Context;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
/*
class Assignment implements Expression{
	var reference:Reference;
  var expression:Expression;
	var modifier:Functions;

	var signature:Node_Signature;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
			signature = Type_Network.analyze(expression, reference.get_type(), scope);
			var input = expression.to_port(scope, null, signature);
			var output = reference.to_port(scope);
			return new Assignment_Node(output, input).get_port(0);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ new Type_Signature(Kind.none) ] ];
	}

	public function to_string():String {
		return "Node Scope";
	}

	public function get_children():Array<Expression> {
		return [];
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		throw new Exception("Not implemented.");
	}
}*/