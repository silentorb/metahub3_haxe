package metahub.code.statements;
import metahub.code.expressions.Expression_Statement;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Setter_Node;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Block implements Expression_Statement {

  public var statements = new Array<Statement>();
  public var type:Type_Signature = new Type_Signature(Kind.any);
  var scope_definition:Scope_Definition;

  public function new(scope_definition:Scope_Definition) {
    this.scope_definition = scope_definition;
  }

	public function add(statement:Statement) {
		statements.push(statement);
	}

  public function resolve(scope:Scope):Dynamic {
    var scope = new Scope(scope.hub, scope_definition, scope);

    for (s in statements) {
      s.resolve(scope);
    }
    return null;
  }

	public function get_type():Type_Signature {
		throw new Exception("Block.get_type() is not implemented.");
	}

  public function resolve(scope:Scope):Dynamic {
    return value;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		//var node = new Setter_Node(

  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ possible_type ] ];
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