package metahub.code.expressions;
import metahub.code.Scope_Definition;
import metahub.engine.General_Port;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Trellis_Scope implements Expression {
  public var trellis:Trellis;
  var statements:Array<Expression>;
  public var type:Type_Signature;
	var scope_definition:Scope_Definition;

  public function new(trellis:Trellis, statements:Array<Expression>, scope_definition:Scope_Definition) {
    this.trellis = trellis;
    this.statements = statements;
		this.scope_definition = scope_definition;
  }

  //public function resolve(scope:Scope):Dynamic {
    //var new_scope = new Scope(scope.hub, scope_definition, scope);
    //for (statement in statements) {
      //statement.resolve(new_scope);
    //}
//
    //return null;
  //}

  public function to_port(scope:Scope, group:Group):General_Port {
    return null;
  }

	public function get_type():Type_Signature {
		throw new Exception("Trellis_Scope.get_type() is not implemented.");
	}
}