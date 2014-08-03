package metahub.code.statements;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Node implements Statement {
  public var trellis:Trellis;
  public var assignments = new Map<Int, Statement>();
  public var trellis_type:Type_Signature;

  public function new(trellis:Trellis) {
    this.trellis = trellis;
    trellis_type = new Type_Signature(Kind.reference, trellis);
  }

  public function resolve(scope:Scope):Dynamic {
		trace('create node', trellis.name);
    var node = scope.hub.create_node(trellis);
    for (i in assignments.keys()) {
      var statement = assignments[i];
      node.set_value(i, statement.resolve(scope));
    }

    return node.id;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_type():Type_Signature {
		return trellis_type;
	}
}