package code.expressions;
import code.references.*;
import engine.IPort;

import schema.Trellis;
import engine.Node;

class Expression_Reference<S> implements Expression {
  public var reference:Reference<S>;
  public var type:Type_Reference;

  public function new(reference:Reference<S>) {
    this.reference = reference;
  }

  public function resolve(scope:Scope):Dynamic {
    return reference.resolve(scope);
  }

  public function to_port(scope:Scope):IPort {
		throw new Exception("Not supported");
    //return reference.get_port(scope);
  }
}