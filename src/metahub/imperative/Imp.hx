package metahub.imperative;
import metahub.imperative.code.Reference;
import metahub.imperative.code.List;
import metahub.imperative.schema.*;
import metahub.meta.Scope;
import metahub.imperative.types.*;
import metahub.meta.types.Scope_Expression;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.imperative.code.Parse;

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
	
	public function run(root:Expression) {
		process(root, null);
		generate_code();
		
		for (constraint in constraints) {
			implement_constraint(constraint);
		}
		
		flatten();
	}
	
	public function generate_code() {
		for (region in railway.regions) {
			if (region.is_external)
				continue;
				
			for (rail in region.rails) {
				if (rail.is_external)
					continue;
					
				rail.generate_code();
			}
		}
	}

	public function flatten() {
		for (region in railway.regions) {
			if (region.is_external)
				continue;
				
			for (rail in region.rails) {
				if (rail.is_external)
					continue;

				rail.flatten();
			}
		}
	}
	
	public function process(expression:Expression, scope:Scope) {
		switch(expression.type) {
			case metahub.meta.types.Expression_Type.scope:
				scope_expression(cast expression, scope);

			case metahub.meta.types.Expression_Type.block:
				block_expression(cast expression, scope);

			case metahub.meta.types.Expression_Type.constraint:
				create_constraint(cast expression, scope);

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

	function block_expression(expression:metahub.meta.types.Block, scope:Scope) {
		for (child in expression.children) {
			process(child, scope);
		}
	}

	function create_constraint(expression:metahub.meta.types.Constraint, scope:Scope) {
		var rail = get_rail(scope.trellis);
		var constraint = new metahub.imperative.schema.Constraint(expression, this, scope);
		var tie = Parse.get_end_tie(constraint.reference);
		trace('tie', tie.rail.name + "." + tie.name);
		tie.constraints.push(constraint);
		constraints.push(constraint);
	}

	public function get_rail(trellis:Trellis):Rail {
		return railway.get_rail(trellis);
	}

	public function implement_constraint(constraint:Constraint) {
		var tie = Parse.get_end_tie(constraint.reference);
		
		if (tie.type == Kind.list) {
			List.generate_constraint(constraint);
		}
		else {
			tie.rail.concat_block(tie.tie_name + "_set_pre", Reference.constraint(constraint));
		}
	}
	
	public function translate(expression:metahub.meta.types.Expression):Expression {
		switch(expression.type) {
			case metahub.meta.types.Expression_Type.literal:
				var literal:metahub.meta.types.Literal = cast expression;
				return new Literal(literal.value);

			case metahub.meta.types.Expression_Type.function_call:
				var func:metahub.meta.types.Function_Call = cast expression;
				return new Function_Call(func.name, [translate(func.input)]);
				
			case metahub.meta.types.Expression_Type.path:
				return convert_path(cast expression);
				
			case metahub.meta.types.Expression_Type.block:
				var array:metahub.meta.types.Block = cast expression;
				return new Create_Array(array.children.map(function(e) return translate(e)));

			default:
				throw new Exception("Cannot convert expression " + expression.type + ".");
		}
		
		
	}
	
	public function convert_path(expression:metahub.meta.types.Path):Expression {
		var path = expression.children;
		var result = new Array<metahub.imperative.types.Expression>();
		var first:metahub.meta.types.Property_Expression = cast path[0];
		var rail = railway.get_rail(first.property.trellis);
		for (token in path) {
			if (token.type == metahub.meta.types.Expression_Type.property) {
				var property_token:metahub.meta.types.Property_Expression = cast token;
				var tie = rail.all_ties[property_token.property.name];
				if (tie == null)
					throw new Exception("tie is null: " + property_token.property.fullname());

				result.push(new Property_Expression(tie));
				rail = tie.other_rail;
			}
			else {
				var function_token:metahub.meta.types.Function_Call = cast token;
				result.push(new Function_Call(function_token.name, [], true));
			}
		}
		return new metahub.imperative.types.Path(result);
	}
}