package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.code.Scope_Definition;
import metahub.code.expressions.Block;
import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Node_Scope implements Expression {
	var scope_definition:Scope_Definition;
	var expression:Expression;
	public var children:Array<Expression>;

  public function new(expression:Expression, scope_definition:Scope_Definition) {
    this.expression = expression;
		this.scope_definition = scope_definition;
		children = [ expression ];
  }

  //public function resolve(scope:Scope):Dynamic {
    //var new_scope = new Scope(scope.hub, scope_definition, scope);
		//new_scope.node = scope_definition.symbol.resolve(scope);
		//return block.resolve(new_scope);
  //}

	public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var new_scope = new Scope(scope.hub, scope_definition, scope);
		new_scope.node = scope_definition.symbol.resolve(scope);
		return expression.to_port(new_scope, group, signature_node);
  }

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		return null;
	}

	public function to_string():String {
		return expression.to_string();
	}

	public function get_children():Array<Expression> {
		return expression.children;
	}
}