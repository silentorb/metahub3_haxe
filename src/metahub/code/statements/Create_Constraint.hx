package metahub.code.statements;

import metahub.code.expressions.Expression;
import metahub.code.references.Property_Reference;
import metahub.code.references.Reference;
import metahub.code.symbols.Property_Symbol;
import metahub.engine.Constraint_Operator;
import metahub.engine.General_Port;
import metahub.code.reference.*;

class Create_Constraint<S> implements Statement {
  public var type:Type_Signature;
  var reference:Reference<S>;
  var expression:Expression;

  public function new(reference:Reference<S>, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		var group = new Group();
		scope.hub.constraints.push(group);
		var other_port = expression.to_port(scope, group, null);

		if (reference.get_layer() == Layer.schema) {
			var property_reference:Property_Reference = cast reference;
			var port = property_reference.get_port(scope);
			port.connect(other_port);
			return null;
		}

		throw new Exception("Not implemented yet.");
  }

	public function get_type():Type_Signature {
		return reference.get_type_reference();
	}
}