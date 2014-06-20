package metahub.code.expressions;
import metahub.code.Scope_Definition;
import metahub.engine.IPort;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Trellis_Scope implements Expression {
  public var trellis:Trellis;
  var expressions:Array<Expression>;
  public var type:Type_Reference;
	var scope_definition:Scope_Definition;

  public function new(trellis:Trellis, expressions:Array<Expression>, scope_definition:Scope_Definition) {
    this.trellis = trellis;
    this.expressions = expressions;
		this.scope_definition = scope_definition;
  }

  public function resolve(scope:Scope):Dynamic {
    var new_scope = new Scope(scope.hub, scope_definition, scope);
    for (expression in expressions) {
      expression.resolve(new_scope);
    }

    return null;
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}