package metahub.code.expressions;

import metahub.engine.IPort;
import metahub.schema.Trellis;

class Trellis_Constraint implements Expression {
	var property:Property;
  public var type:Type_Reference;
  var expression:Expression;

  public function new(property:Property, expression:Expression) {
    this.property = property;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
    var port = reference.get_port(scope);
    var other_port = expression.to_port(scope);
    port.add_dependency(other_port);

    return null;
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}