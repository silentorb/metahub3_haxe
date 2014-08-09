package metahub.code.expressions;
import metahub.code.Scope_Definition;
import metahub.code.statements.Block;
import metahub.code.statements.Statement;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Node_Scope implements Statement {
	var scope_definition:Scope_Definition;
	var block:Block;

  public function new(block:Block, scope_definition:Scope_Definition) {
    this.block = block;
		this.scope_definition = scope_definition;
  }

  public function resolve(scope:Scope):Dynamic {
    var new_scope = new Scope(scope.hub, scope_definition, scope);
		new_scope.node = scope_definition.symbol.resolve(scope);
		return block.resolve(new_scope);
  }
}