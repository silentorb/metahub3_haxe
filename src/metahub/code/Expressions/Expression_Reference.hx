package metahub.code.expressions;
import metahub.code.references.*;
import metahub.engine.IPort;

import metahub.schema.Trellis;
import metahub.engine.Node;

class Expression_Reference<S> implements Expression {
  public var reference:Reference<S>;
  public var type:Type_Reference;

  public function new(reference:Reference<S>) {
    this.reference = reference;
  }

  public function resolve(scope:Scope):Dynamic {
    return reference.resolve(scope).id;
  }

  public function to_port(scope:Scope):IPort {
		//if (reference.get_layer() ==
		//throw new Exception("Not supported");
    return reference.get_port(scope);
  }
}