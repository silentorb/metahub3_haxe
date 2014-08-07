package metahub.code.statements;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Assignment implements Statement{
	var reference:Reference;
  var expression:Expression;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope) {
		var port = reference.to_port(scope);
		var input_type = reference.get_type();
		port.set_node_value(Expression_Utility.resolve(expression, input_type, scope), null, null);
  }
}