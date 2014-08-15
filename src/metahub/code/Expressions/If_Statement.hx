package metahub.code.expressions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class If_Statement extends Expression {

	public function new() {

	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_types():Array<Array<Type_Signature>>{
		return [ [ trellis_type ] ];
	}

	public function to_string():String {
		return "new " + trellis.name;
	}

	public function get_children():Array<Expression> {
		return [];
	}
}