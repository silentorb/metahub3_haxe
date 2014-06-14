package code.expressions;

import code.references.Property_Reference;
import code.references.Reference;
import code.symbols.Property_Symbol;
import engine.IPort;
import code.reference.*;

class Create_Constraint<S> implements Expression {
  public var type:Type_Reference;
  var reference:Reference<S>;
  var expression:Expression;

  public function new(reference:Reference<S>, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function resolve(scope:Scope):Dynamic {
		trace('constraint', Type.getClassName(Type.getClass(reference)));
		var other_port = expression.to_port(scope);
		/*
		if (Type.getClass(reference) == Property_Reference) {
			var property_reference:Property_Reference = cast reference;
			trace('constraint');
			property_reference.get_port(scope);
			//property_reference.resolve(

		}
		else {
			//var port = reference.get_port(scope);
			//var other_port = expression.to_port(scope);
			//port.add_dependency(other_port);
		}
*/
		if (reference.get_layer() == Layer.schema) {
			var property_reference:Property_Reference = cast reference;
			var port = property_reference.get_port(scope);
			port.add_dependency(other_port);
			return null;
		}
		else {

		}

		throw new Exception("Not implemented yet.");
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}