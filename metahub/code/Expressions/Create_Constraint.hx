package code.expressions;

import engine.IPort;

class Create_Constraint implements Expression {
  public var type:Type_Reference;
  var reference:Symbol_Reference;
  var expression:Expression;

  public function new(reference:Symbol_Reference, expression:Expression) {
    this.reference = reference;
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