package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.code.Scope;
import metahub.code.Scope_Definition;
import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Scope_Expression implements Expression {
	var expression:Expression;
	var scope_definition:Scope_Definition;
	public var children :Array<Expression>;

  public function new(expression:Expression, scope_definition:Scope_Definition) {
    this.expression = expression;
		this.scope_definition = scope_definition;
		children = [ expression ];
  }

  public function to_port(scope:Scope, group:Group, signature:Type_Signature):General_Port {
    var new_scope = new Scope(scope.hub, scope_definition, scope);
		return expression.to_port(new_scope, group, null);
  }

	public function get_type(out_type:Type_Signature = null):Array<Type_Signature> {
		return null;
	}

	public function to_string():String {
		return scope_definition.trellis.name;
	}
}