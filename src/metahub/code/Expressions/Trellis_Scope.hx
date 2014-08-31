package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.code.Scope;
import metahub.code.Scope_Definition;
import metahub.engine.General_Port;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Trellis_Scope implements Expression {
  public var trellis:Trellis;
	var expression:Expression;
  public var type:Type_Signature;
	var scope_definition:Scope_Definition;
	public var children :Array<Expression>;

  public function new(trellis:Trellis, expression:Expression, scope_definition:Scope_Definition) {
    this.trellis = trellis;
    this.expression = expression;
		this.scope_definition = scope_definition;
		children = [ expression ];
  }

  public function to_port(scope:Scope, group:Group, signature:Node_Signature):General_Port {
    var new_scope = new Scope(scope.hub, scope_definition, scope);
		return expression.to_port(new_scope, group, signature);
  }

	public function get_types():Array<Array<Type_Signature>> {
		return expression.get_types();
	}

	public function to_string():String {
		return expression.to_string();
	}

	public function get_children():Array<Expression> {
		return expression.children;
	}
}