package metahub.imperative.code;
import metahub.imperative.schema.Constraint;
import metahub.imperative.schema.Rail;
import metahub.imperative.schema.Tie;
import metahub.imperative.types.*;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class List
{
	public static function common_functions(tie:Tie) {
		var rail = tie.rail;
		var definition = new Function_Definition(tie.tie_name + "_add", rail, [
			new Parameter("item", tie.get_other_signature())], [
			new Property_Expression(tie,
				new Function_Call("add", [ new Variable("item") ], true)
			)		
		]);
		
		if (tie.other_tie != null) {
			//throw "";
			definition.block.push(
				new Assignment(new Variable("item", new Property_Expression(tie.other_tie)),
				"=", new Self())
			);
		}
		
		rail.add_to_block("/", definition);
	}
	
	public static function generate_constraint(constraint:Constraint) {
		var path:Path = cast constraint.reference;
		var property_expression:Property_Expression = cast path.children[0];
		var reference = property_expression.tie;
		//var amount:Int = target.render_expression(constraint.expression, constraint.scope);
		var expression = Code.convert_expression(constraint.expression, constraint.scope);

		if (constraint.expression.type == metahub.meta.types.Expression_Type.function_call) {
			var func:metahub.meta.types.Function_Call = cast constraint.expression;
			if (func.name == "map") {
				map(constraint, expression);
				return;
			}
		}
			
		size(constraint, expression);
	}
	
	public static function map(constraint:Constraint, expression:Expression) {
		
	}

	public static function size(constraint:Constraint, expression:Expression) {
		var path:Path = cast constraint.reference;
		var property_expression:Property_Expression = cast path.children[0];
		var reference = property_expression.tie;
		
		var instance_name = reference.other_rail.rail_name;
		var rail = reference.other_rail;
		var local_rail:Rail = reference.rail;
		var child = "child";
		var flow_control = new Flow_Control("while", {
			operator: "<",
			expressions: [
				constraint.reference,
				//{ type: "path", path: constraint.reference },
				expression
			]
			},[
			new Declare_Variable(child, {
					type: Kind.reference,
					rail: rail,
					is_value: false
			}, new Instantiate(rail)),
			new Variable(child, new Function_Call("initialize")),
			new Function_Call(reference.tie_name + "_add", 
				[new Variable(child)])

	]);
		

		local_rail.add_to_block("initialize", flow_control);
	}

}