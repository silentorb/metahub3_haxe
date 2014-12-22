package metahub.imperative.code;
import metahub.imperative.Imp;
import metahub.logic.schema.Constraint;
import metahub.logic.schema.Rail;
import metahub.logic.schema.Tie;
import metahub.imperative.types.*;
import metahub.meta.types.Lambda;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class List
{
	public static function common_functions(tie:Tie, imp:Imp) {
		var rail = tie.rail;
		var dungeon = imp.get_dungeon(tie.rail);
		
		var function_name = tie.tie_name + "_add";
		var definition = new Function_Definition(function_name, dungeon, [
			new Parameter("item", tie.get_other_signature()),
			new Parameter("origin", { type: Kind.reference, rail: null })
			], []);

		var zone = dungeon.create_zone(definition.expressions);
		var mid = zone.divide(null, [
			new Property_Expression(tie,
				new Function_Call("add", [ new Variable("item") ], true)
			)
		]);
		var post = zone.divide(function_name + "_post");

		if (tie.other_tie != null) {
			//throw "";
			mid.push(
				new Assignment(new Variable("item", new Property_Expression(tie.other_tie)),
				"=", new Self())
			);
		}

		dungeon.add_to_block("/", definition);
	}

	public static function generate_constraint(constraint:Constraint, imp:Imp) {
		var path:Path = cast constraint.reference;
		var property_expression:Property_Expression = cast path.children[0];
		var reference = property_expression.tie;
		//var amount:Int = target.render_expression(constraint.expression, constraint.scope);
		var expression = constraint.expression;

		//if (constraint.expression.type == metahub.meta.types.Expression_Type.function_call) {
			//var func:metahub.meta.types.Function_Call = cast constraint.expression;
			//if (func.name == "map") {
				//map(constraint, expression, imp);
				//return;
			//}
		//}
		
		var other_path = Parse.get_path(expression);
		if (other_path.length > 0 && other_path[other_path.length - 1].type == Kind.list) {
			map(constraint, expression, imp);
		}
		else {
			size(constraint, expression, imp);			
		}
	}

	public static function map(constraint:Constraint, expression:metahub.meta.types.Expression, imp:Imp) {
		var start = Parse.get_start_tie(constraint.reference);
		var end = Parse.get_end_tie(constraint.reference);
		var path:metahub.meta.types.Path = cast constraint.expression;

		var a = Parse.get_path(constraint.reference);
		var b = Parse.get_path(path);

		link(a, b, Parse.reverse_path(b.slice(0, a.length - 1)), constraint.lambda, imp);
		link(b, a, a.slice(0, a.length - 1), constraint.lambda, imp);
	}

	public static function link(a:Array<Tie>, b:Array<Tie>, c:Array<Tie>, mapping:Lambda, imp:Imp) {
		var a_start = a[0];
		var a_end = a[a.length - 1];
		
		var second_start = b[0];
		var second_end = b[b.length - 1];
			
		var item_name = second_end.rail.name.toLowerCase() + "_item";
	
		var creation_block:Array<Expression> = [
			new Declare_Variable(item_name, second_end.get_other_signature(), new Instantiate(second_end.other_rail)),
		];
		
		if (mapping != null) {
			var constraints:Array<metahub.meta.types.Constraint> = cast mapping.expressions;
			for (constraint in constraints) {
				var first:metahub.meta.types.Path = cast constraint.first;
				var first_tie:metahub.meta.types.Property_Expression = cast first.children[1];
				var second:metahub.meta.types.Path = cast constraint.second;
				var second_tie:metahub.meta.types.Property_Expression = cast second.children[1];
				creation_block.push(new Assignment(
					new Variable(item_name, new Property_Expression(cast a_end.other_rail.get_tie_or_error(first_tie.tie.name))), 
					"=",
					new Variable("item", new Property_Expression(cast second_end.other_rail.get_tie_or_error(second_tie.tie.name)))
				));
			}
		}
		
		creation_block = creation_block.concat(cast [
			new Variable(item_name, new Function_Call("initialize")),
			new Property_Expression(c[0],
				new Function_Call(second_end.tie_name + "_add",
					[new Variable(item_name), new Self()])
			)
		]);

		var block:Array<Expression> = [
				new Flow_Control("if", new Condition("!=", [
				new Variable("origin"), new Property_Expression(c[0])]), creation_block)
		];

		if (a_start.other_tie.property.allow_null) {
			block = [
				new Flow_Control("if",
					new Condition("!=", [ new Property_Expression(a_start.other_tie),
					new Null_Value() ]), block
				)
			];
		}
		imp.get_dungeon(a_end.rail).concat_block(a_end.tie_name + "_add_post", block);
	}

	public static function size(constraint:Constraint, expression:metahub.meta.types.Expression, imp:Imp) {
		var path:Path = cast constraint.reference;
		var property_expression:Property_Expression = cast path.children[0];
		var reference = property_expression.tie;

		var instance_name = reference.other_rail.rail_name;
		var rail = reference.other_rail;
		var local_rail:Rail = reference.rail;
		var child = "child";
		var flow_control = new Flow_Control("while", new Condition("<",
			[
				imp.translate(constraint.reference),
				//{ type: "path", path: constraint.reference },
				imp.translate(expression)
			]),[
			new Declare_Variable(child, {
					type: Kind.reference,
					rail: rail,
					is_value: false
			}, new Instantiate(rail)),
			new Variable(child, new Function_Call("initialize")),
			new Function_Call(reference.tie_name + "_add",
				[new Variable(child), new Null_Value()])
	]);
		imp.get_dungeon(local_rail).add_to_block("initialize", flow_control);
	}

}