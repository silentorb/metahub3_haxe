package metahub.code.expressions;
import metahub.code.Context_Converter;
import metahub.code.references.*;
import metahub.engine.General_Port;

import metahub.schema.Trellis;
import metahub.engine.Node;

class Expression_Reference<S> implements Expression {
  public var reference:Reference<S>;

  public function new(reference:Reference<S>) {
    this.reference = reference;
  }

  public function resolve(scope:Scope):Dynamic {
    return reference.resolve(scope).id;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		//if (reference.get_layer() ==
		//throw new Exception("Not supported");
		var port = reference.resolve_port(scope);
		var chain = reference.chain;
		var converter = reference.create_converter(scope);
		if (converter != null) {
			converter.ports[1].connect(port);
			port = converter.ports[0];
		}

		group.nodes.unshift(port.node);
		return port;
  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ reference.get_type_reference() ] ];
	}
		
	public function to_string():String {
		return "Expression_Reference";
	}
	
	public function get_children():Array<Expression> {
		return [];
	}
	
	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		return reference.resolve(scope);
	}
}