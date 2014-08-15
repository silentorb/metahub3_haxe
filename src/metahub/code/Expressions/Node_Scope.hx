package metahub.code.expressions;
import metahub.code.Scope_Definition;
import metahub.code.expressions.Block;
import metahub.code.statements.Statement;
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
	var block:Block;

  public function new(block:Block, scope_definition:Scope_Definition) {
    this.block = block;
		this.scope_definition = scope_definition;
  }

  //public function resolve(scope:Scope):Dynamic {
    //var new_scope = new Scope(scope.hub, scope_definition, scope);
		//new_scope.node = scope_definition.symbol.resolve(scope);
		//return block.resolve(new_scope);
  //}
	
	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var new_scope = new Scope(scope.hub, scope_definition, scope);
		new_scope.node = scope_definition.symbol.resolve(scope);
		return block.to_port(new_scope, group, signature_node);
  }
	
	public function get_types():Array<Array<Type_Signature>> {
		return block.get_types();
	}

	public function to_string():String {
		return "Node Scope";
	}

	public function get_children():Array<Expression> {
		return block.get_children();
	}
}