package metahub.code.statements;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Block implements Statement {

  public var statements = new Array<Statement>();
  public var type:Type_Signature = new Type_Signature(Kind.any);
  var scope_definition:Scope_Definition;

  public function new(scope_definition:Scope_Definition) {
    this.scope_definition = scope_definition;
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
}