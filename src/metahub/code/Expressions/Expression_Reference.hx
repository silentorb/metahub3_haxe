package metahub.code.expressions;
import metahub.code.nodes.Context_Converter;
import metahub.code.references.*;
import metahub.engine.General_Port;
import metahub.code.nodes.Group;
import metahub.schema.Trellis;
import metahub.engine.Node;
import metahub.code.nodes.Path_Condition;

class Expression_Reference implements Expression {
  public var reference:Reference;
	public var children = new Array<Expression>();

  public function new(reference:Reference) {
    this.reference = reference;
  }

  //public function resolve(scope:Scope):Dynamic {
    //return reference.resolve(scope).id;
  //}

  public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var result = reference.to_port(scope, group);
		if (reference.path.length > 1) {
			var condition = new Path_Condition(reference.path, scope.definition.trellis, group);
			condition.get_port(0).connect(result);
			return condition.get_port(1);
		}

		return result;
  }

	public function get_type(out_type:Type_Signature = null):Array<Type_Signature> {
		return [ reference.get_type() ];
	}

	public function to_string():String {
		return reference.to_string();
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		return reference.resolve(scope);
	}
}