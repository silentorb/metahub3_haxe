package metahub.code.statements;
import metahub.code.expressions.Expression_Statement;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Block_Node;
import metahub.code.Type_Signature;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Block implements Expression_Statement {

  public var statements = new Array<Statement>();
  public var type:Type_Signature = new Type_Signature(Kind.any);

  //public function new(scope_definition:Scope_Definition) {
    //this.scope_definition = scope_definition;
  //}

	public function add(statement:Statement) {
		statements.push(statement);
	}

  public function resolve(scope:Scope):Dynamic {
    //var scope = new Scope(scope.hub, scope_definition, scope);

    for (s in statements) {
      s.resolve(scope);
    }
    return null;
  }

	public function get_type():Type_Signature {
		throw new Exception("Block.get_type() is not implemented.");
	}

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var node = new Block_Node(this, scope);
		return node.get_port(0);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return [ [ new Type_Signature(Kind.pulse)] ];
	}

	public function to_string():String {
		return "Block";
	}

	public function get_children():Array<Expression> {
		return [];
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		throw new Exception("Not implemented.");
	}
}