package metahub.imperative.code ;
import metahub.imperative.schema.Constraint;
import metahub.imperative.schema.Rail;
import metahub.imperative.schema.Railway;
import metahub.imperative.types.*;
import metahub.meta.Scope;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Code
{
	public static var inverse_operators = {
		">": "<=",
		"<": ">=",
		">=": "<",
		"<=": ">"
	}

	public static function constraint(constraint:Constraint):Array<Expression> {
		var operator = constraint.operator;
		var inverse = Reflect.field(inverse_operators, operator);
		var conversion:Literal = cast convert_expression(constraint.expression, constraint.scope);
		var limit:Float = conversion.value;

		var min:Float = 0.0001;
		var value:Float = 0;
		switch(operator) {
			case '<':
				value = limit - min;
			case '>':
				value = limit + min;
			case '<=':
				value = limit;
			case '>=':
				value = limit;
		}

		return [ new Flow_Control("if",	{
				operator: inverse,
				expressions: [
					constraint.reference,
					{ type: Expression_Type.literal, value: limit }
				]
			},
			[
				new Assignment(constraint.reference, "=", new Literal(value))
			]
		)];
	}

	public static function convert_expression(expression:metahub.meta.types.Expression, scope:Scope):Expression {

		switch(expression.type) {
			case Expression_Type.literal:
				var literal:metahub.meta.types.Literal = cast expression;
				return new Literal(literal.value);

			case Expression_Type.function_call:
				var func:metahub.meta.types.Function_Call = cast expression;
				return new Function_Call(func.name);

			default:
				throw new Exception("Cannot convert expression " + expression.type + ".");
		}

	}

}