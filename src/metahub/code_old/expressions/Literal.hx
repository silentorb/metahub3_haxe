package metahub.code.expressions;
import metahub.engine.General_Port;
import metahub.code.nodes.Literal_Node;
import metahub.schema.Kind;
import metahub.code.nodes.Group;

class Literal implements Expression {
  public var value:Dynamic;
  public var possible_type:Type_Signature;
	public var children = new Array<Expression>();

  public function new(value:Dynamic, type:Type_Signature) {
    this.value = value;
    possible_type = type;
  }

  public function resolve(scope:Scope):Dynamic {
    return value;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var node = new Literal_Node(value, group);
    return node.get_port(0);
  }

	public function get_type(out_type:Type_Signature = null):Array<Type_Signature> {
		return [ possible_type ];
	}

	public function to_string():String {
		return value;
	}

	public function get_children():Array<Expression> {
		return [];
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		return value;
	}
}