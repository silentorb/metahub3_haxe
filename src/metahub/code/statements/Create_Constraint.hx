package metahub.code.statements;

import metahub.code.expressions.Expression;
import metahub.code.references.Property_Reference;
import metahub.code.references.Reference;
import metahub.code.symbols.Property_Symbol;
import metahub.engine.Constraint_Operator;
import metahub.engine.General_Port;
import metahub.code.reference.*;

class Create_Constraint implements Statement {
  public var type:Type_Signature;
  var reference:Reference;
  var expression:Expression;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		//if (reference.get_layer() != Layer.schema)
			//throw new Exception("Not implemented.");

		var port = reference.to_port(scope);

		var group = new Group();
		scope.hub.constraints.push(group);
		var signature = Type_Network.analyze(expression, reference.get_type(), scope);
		var other_port = expression.to_port(scope, group, signature);


		port.connect(other_port);
		return null;
  }

}