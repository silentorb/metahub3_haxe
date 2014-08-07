package metahub.code.expressions;
import metahub.code.expressions.Expression;
import metahub.code.Setter;
import metahub.code.statements.Statement;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Node implements Expression_Statement {
  public var trellis:Trellis;
  //public var assignments = new Map<Int, Expression>();
	public var setter:Setter;
  public var trellis_type:Type_Signature;

  public function new(trellis:Trellis) {
    this.trellis = trellis;
    trellis_type = new Type_Signature(Kind.reference, trellis);
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

	public function resolve(scope:Scope):Dynamic {
		trace('create node', trellis.name);
    var node = scope.hub.create_node(trellis);
		setter.run(node, scope);
    //for (i in assignments.keys()) {
      //var statement = assignments[i];
			//var input_type = Type_Signature.from_property(trellis.properties[i]);
      //node.set_value(i, Expression_Utility.resolve(statement, input_type, scope));
    //}

    return node.id;
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		return resolve(scope);
	}
}