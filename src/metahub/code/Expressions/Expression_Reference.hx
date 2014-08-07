package metahub.code.expressions;
import metahub.code.nodes.Context_Converter;
import metahub.code.references.*;
import metahub.engine.General_Port;

import metahub.schema.Trellis;
import metahub.engine.Node;

class Expression_Reference implements Expression {
  public var reference:Reference;

  public function new(reference:Reference) {
    this.reference = reference;
  }

  //public function resolve(scope:Scope):Dynamic {
    //return reference.resolve(scope).id;
  //}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		//if (reference.get_layer() ==
		//throw new Exception("Not supported");
		return reference.to_port(scope);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ reference.get_type() ] ];
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