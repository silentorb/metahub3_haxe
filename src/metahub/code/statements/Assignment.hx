package metahub.code.statements;
import metahub.code.expressions.Expression;
//import metahub.code.expressions.Expression_Utility;
import metahub.code.functions.Functions;
import metahub.code.nodes.Assignment_Node;
import metahub.code.references.Reference;
import metahub.code.Type_Signature;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.Node_Context;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment implements Expression{
	var reference:Reference;
  var expression:Expression;
	var modifier:Functions;

	var signature:Node_Signature;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  //public function resolve(scope:Scope):Dynamic {
		//if (output == null) {
			//signature = Type_Network.analyze(expression, reference.get_type(), scope);
			//input = expression.to_port(scope, null, signature);
			//output = reference.to_port(scope);
		//}
//
		//var context = new Node_Context(scope.node, scope.hub);
		//var value = input == null
			//? Expression_Utility.resolve(expression, reference.get_type(), scope)
			//: input.get_node_value(context);
//
		//output.set_node_value(value, context, null);
		//return value;
  //}
	
	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
			signature = Type_Network.analyze(expression, reference.get_type(), scope);
			var input = expression.to_port(scope, null, signature);
			var output = reference.to_port(scope);
			return new Assignment_Node(output, input).get_port(0);
  }
	
	public function get_types():Array<Array<Type_Signature>> {
		return [ [ new Type_Signature(Kind.any) ] ];
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
}