package metahub.code.statements;

import metahub.code.expressions.Expression;
import metahub.code.nodes.Group;
import metahub.code.nodes.Path_Condition;
import metahub.code.Reference;
import metahub.engine.Constraint_Operator;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Constraint implements Expression {
  public var type:Type_Signature;
  var reference:Reference;
  var expression:Expression;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

/*
  public function resolve(scope:Scope):Dynamic {
		//if (reference.get_layer() != Layer.schema)
			//throw new Exception("Not implemented.");

		var port = reference.to_port(scope);

		var group = new Group();
		scope.hub.constraints.push(group);
		var signature = Type_Network.analyze(expression, reference.get_type(), scope);
		var other_port = expression.to_port(scope, group, signature);

		if (reference.path.length > 1) {
			var condition = new Path_Condition(reference.path, scope.definition.trellis);
			condition.get_port(1).connect(other_port);
			port.connect(condition.get_port(0));
		}
		else {
			port.connect(other_port);
		}

		return null;
  }
	*/

	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var port = reference.to_port(scope);

		var group = new Group();
		scope.hub.constraints.push(group);
		var signature = Type_Network.analyze(expression, reference.get_type(), scope);
		var other_port = expression.to_port(scope, group, signature);

		if (reference.path.length > 1) {
			var condition = new Path_Condition(reference.path, scope.definition.trellis);
			condition.get_port(1).connect(other_port);
			port.connect(condition.get_port(0));
		}
		else {
			port.connect(other_port);
		}

		return port;
  }

	public function get_types():Array<Array<Type_Signature>> {
		return expression.get_types();
	}

	public function to_string():String {
		return expression.to_string();
	}

	public function get_children():Array<Expression> {
		return expression.get_children();
	}
}