package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Expression_Utility;
import metahub.code.functions.Functions;
import metahub.code.references.Reference;
import metahub.engine.Node_Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment implements Statement{
	var reference:Reference;
  var expression:Expression;
	var modifier:Functions;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		var port = reference.to_port(scope);
		var input_type = reference.get_type();
		var value = Expression_Utility.resolve(expression, input_type, scope);
		var context = new Node_Context(scope.node, scope.hub);
		port.set_node_value(value, context, null);
		return value;
  }
}