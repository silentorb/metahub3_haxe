package metahub.code.expressions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class New_Block implements Expression {
	public var children:Array<Expression>;

  public function new(expression:Expression) {
    children = [ expression ];
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
}