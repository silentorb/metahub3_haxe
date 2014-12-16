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
class Reference
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
		var conversion:Literal = cast constraint.expression;
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

		return [ new Flow_Control("if",	new Condition(inverse,
				[
					constraint.reference,
					{ type: Expression_Type.literal, value: limit }
				]
			),
			[
				new Assignment(constraint.reference, "=", new Literal(value))
			]
		)];
	}

	//public static function convert_expression(expression:metahub.meta.types.Expression, scope:Scope):Expression {
//
		//
//
	//}

}