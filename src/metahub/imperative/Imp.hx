package metahub.imperative;
import metahub.imperative.code.Reference;
import metahub.imperative.code.List;
import metahub.imperative.schema.*;
import metahub.logic.schema.*;
import metahub.meta.Scope;
import metahub.imperative.types.*;
import metahub.meta.types.Lambda;
import metahub.meta.types.Scope_Expression;
import metahub.render.Target;
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
	public var dungeons = new Array<Dungeon>();
	var rail_map = new Map<Rail, Dungeon>();

	public function new(hub:Hub, target_name:String)
	{
		railway = new Railway(hub, target_name);
	}

	public function run(root:metahub.meta.types.Expression, target:Target) {
		process(root, null);
		generate_code(target);

		for (constraint in constraints) {
			implement_constraint(constraint);
		}

		flatten();
		
		post_analyze();
	}

	public function generate_code(target:Target) {
		
		for (region in railway.regions) {
			if (region.is_external)
				continue;

			for (rail in region.rails) {
				if (rail.is_external)
					continue;
				
				var dungeon = new Dungeon(rail, this);
				dungeons.push(dungeon);
				rail_map[rail] = dungeon;
			}
		}
		
		finalize();
		
		for (dungeon in dungeons) {
			dungeon.generate_code1();
			target.generate_rail_code(dungeon);
			dungeon.generate_code2();
		}
	}
	
	function finalize() {
		for (dungeon in dungeons) {
			dungeon.rail.finalize();
		}
	}
	
	function post_analyze() {
		for (dungeon in dungeons) {
			dungeon.post_analyze_many(dungeon.code);
		}
	}

	public function flatten() {
		for (dungeon in dungeons) {
			dungeon.flatten();
		}
	}
	
	public function get_dungeon(rail:Rail):Dungeon {
		return rail_map[rail];
	}

	public function process(expression:metahub.meta.types.Expression, scope:Scope) {
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
		var rail:Rail = cast scope.rail;
		var constraint = new metahub.logic.schema.Constraint(expression, this);
		var tie = Parse.get_end_tie(constraint.reference);
		trace('tie', tie.rail.name + "." + tie.name);
		tie.constraints.push(constraint);
		constraints.push(constraint);
	}
	
	//function create_lambda_constraint(expression:metahub.meta.types.Constraint, scope:Scope):Expression {
		//throw "";
		//var rail = get_rail(cast scope.trellis);
		//var constraint = new metahub.logic.schema.Constraint(expression, this);
		//var tie = Parse.get_end_tie(constraint.reference);
		//trace('tie', tie.rail.name + "." + tie.name);
		//tie.constraints.push(constraint);
		//constraints.push(constraint);
		//return null;
	//}

	public function get_rail(trellis:Trellis):Rail {
		return railway.get_rail(trellis);
	}

	public function implement_constraint(constraint:Constraint) {
		var tie = Parse.get_end_tie(constraint.reference);

		if (tie.type == Kind.list) {
			List.generate_constraint(constraint, this);
		}
		else {
			var dungeon = get_dungeon(tie.rail);
			dungeon.concat_block(tie.tie_name + "_set_pre", Reference.constraint(constraint, this));
		}
	}

	public function translate(expression:metahub.meta.types.Expression, scope:Scope = null):Expression {
		switch(expression.type) {
			case metahub.meta.types.Expression_Type.literal:
				var literal:metahub.meta.types.Literal = cast expression;
				return new Literal(literal.value, { type:Kind.unknown });

			case metahub.meta.types.Expression_Type.function_call:
				var func:metahub.meta.types.Function_Call = cast expression;
				return new Function_Call(func.name, [translate(func.input)]);

			case metahub.meta.types.Expression_Type.path:
				return convert_path(cast expression);

			case metahub.meta.types.Expression_Type.block:
				var array:metahub.meta.types.Block = cast expression;
				return new Create_Array(array.children.map(function(e) return translate(e)));
				
			case metahub.meta.types.Expression_Type.lambda:
				
				return null;
				//var lambda:metahub.meta.types.Lambda = cast expression;
				//return new Anonymous_Function(lambda.parameters.map(function(p) return new Parameter(p.name, p.signature)),
					//lambda.expressions.map(function(e) return translate(e, lambda.scope))
				//);
//
			//case metahub.meta.types.Expression_Type.constraint:
				//return create_lambda_constraint(cast expression, scope);
			
			default:
				throw new Exception("Cannot convert expression " + expression.type + ".");
		}
	}

	public function convert_path(expression:metahub.meta.types.Path):Expression {
		var path = expression.children;
		var result = new Array<metahub.imperative.types.Expression>();
		var first:metahub.meta.types.Property_Expression = cast path[0];
		var rail:Rail = cast first.tie.get_abstract_rail();
		for (token in path) {
			if (token.type == metahub.meta.types.Expression_Type.property) {
				var property_token:metahub.meta.types.Property_Expression = cast token;
				var tie = rail.all_ties[property_token.tie.name];
				if (tie == null)
					throw new Exception("tie is null: " + property_token.tie.fullname());

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