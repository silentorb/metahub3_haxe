package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Expression_Utility;
import metahub.code.functions.Functions;
import metahub.code.references.Reference;
import metahub.code.Type_Signature;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.Node_Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment implements Statement{
	var reference:Reference;
  var expression:Expression;
	var modifier:Functions;

	var output:General_Port = null;
	var input:General_Port = null;
	var context:Context;
	var signature:Node_Signature;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		if (output == null) {
			signature = Type_Network.analyze(expression, reference.get_type(), scope);
			input = expression.to_port(scope, null, signature);
			output = reference.to_port(scope);
			context = new Node_Context(scope.node, scope.hub);
		}
		var value = input == null
			? Expression_Utility.resolve(expression, reference.get_type(), scope)
			: input.get_node_value(context);

		output.set_node_value(value, context, null);
		return value;
  }
}