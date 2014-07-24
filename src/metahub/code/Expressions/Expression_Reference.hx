package metahub.code.expressions;
import metahub.code.Context_Converter;
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
		var port = reference.get_port(scope);
		var chain = reference.chain;
		var converter = reference.create_converter(scope);
		if (converter != null) {
			converter.input_port.connect(port);
			return converter.output_port;
		}

		return port;
		//if (chain.length > 0) {
			//converter = new Context_Converter(chain[0], chain[chain.length - 1], chain[0].type);
		//}
		//else {
			//return port;
			////var property_reference:Property_Reference = cast reference;
			////converter = new Context_Converter(property_reference.get_property(scope));
		//}

  }
}