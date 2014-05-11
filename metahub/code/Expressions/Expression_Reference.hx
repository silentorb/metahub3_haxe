package code.expressions;
import engine.IPort;

import schema.Trellis;
import engine.Node;

class Expression_Reference implements Expression {
  public var reference:Symbol_Reference;
  public var type:Type_Reference;

  public function new(reference:Symbol_Reference) {
    this.reference = reference;
  }

  public function resolve(scope:Scope):Dynamic {
    return reference.resolve(scope);
  }

  public function to_port(scope:Scope):IPort {
    return reference.get_port(scope);
  }
}