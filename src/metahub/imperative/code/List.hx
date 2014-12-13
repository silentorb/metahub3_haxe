package metahub.imperative.code;
import metahub.imperative.schema.Constraint;
import metahub.imperative.schema.Rail;
import metahub.imperative.types.*;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class List
{
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
	
	public static function map(constraint:Constraint, expression:Expression):Dynamic {
		return null;
	}

	public static function size(constraint:Constraint, expression:Expression) {
		var path:Path = cast constraint.reference;
		var property_expression:Property_Expression = cast path.children[0];
		var reference = property_expression.tie;
		
		var instance_name = reference.other_rail.rail_name;
		var rail = reference.other_rail;
		var local_rail:Rail = reference.rail;
		var flow_control = new Flow_Control("while", {
			operator: "<",
			expressions: [
				constraint.reference,
				//{ type: "path", path: constraint.reference },
				expression
			]
			},[
			new Declare_Variable("_child", {
					type: Kind.reference,
					rail: rail,
					is_value: false
			}, new Instantiate(rail)),
			new Variable("_child", new Function_Call("initialize")),
			new Property_Expression(reference,
				new Function_Call("add", [ new Variable("_child") ], true)
			)
	]);
		

		local_rail.add_to_block("initialize", flow_control);
	}

}