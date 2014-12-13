package metahub.imperative;
import metahub.imperative.schema.*;
import metahub.meta.Scope;
import metahub.meta.types.Expression;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;
import metahub.meta.types.Scope_Expression;
import metahub.meta.types.Block;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.meta.types.Expression_Type;

/**
 * ...
 * @author Christopher W. Johnson
 */
@:expose class Imp
{
	public var railway:Railway;
	public var constraints = new Array<Constraint>();
	
	public function new(hub:Hub, target_name:String) 
	{
		railway = new Railway(hub, target_name);
	}
	
	public function translate(root:Expression) {
		process(root, null);
		generate_code();
	}
		
	public function generate_code() {
		for (region in railway.regions) {
			for (rail in region.rails) {
				rail.generate_code();
			}
		}
	}

	public function process(expression:Expression, scope:Scope) {
		switch(expression.type) {
			case Expression_Type.scope:
				scope_expression(cast expression, scope);

			case Expression_Type.block:
				block_expression(cast expression, scope);

			case Expression_Type.constraint:
				constraint(cast expression, scope);

			default:
				throw new Exception("Cannot process expression of type :" + expression.type + ".");
		}
	}

	function scope_expression(expression:Scope_Expression, scope:Scope) {
		//var new_scope = new Scope(scope.hub, expression.scope_definition, scope);
		for (child in expression.children) {
			process(child, expression.scope);
		}
	}

	function block_expression(expression:Block, scope:Scope) {
		for (child in expression.children) {
			process(child, scope);
		}
	}

	function constraint(expression:metahub.meta.types.Constraint, scope:Scope) {
		var rail = get_rail(scope.trellis);
		var reference:Path = cast expression.first;
		var property_expression:Property_Expression = cast reference.children[0];
		//var tie = rail.all_ties[property_expression.property.name];
		constraints.push(new metahub.imperative.schema.Constraint(expression, rail.railway, scope));
	}

	public function get_rail(trellis:Trellis):Rail {
		return railway.get_rail(trellis);
	}

}