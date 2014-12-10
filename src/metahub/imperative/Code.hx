package metahub.imperative;
import metahub.code.expressions.Literal;
import metahub.code.Scope;
import metahub.generate.Constraint;
import metahub.generate.Railway;

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

	public static function constraint(constraint:Constraint):Array<Statement> {
		var operator = constraint.operator;
		var inverse = Reflect.field(inverse_operators, operator);
		var limit:Float = convert_expression(constraint.expression, constraint.scope);

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
		
		var if_statement:If = {
			type: "if",
			condition: {
				operator: inverse,
				expressions: [
					{ type: "path", path: constraint.reference },
					{ type: "literal", value: limit }
				]
			},
			statements: [
				{
					type: "assignment",
					operator: "=",
					target: constraint.reference,
					expression: { type: "literal", value: value }
				}
			]
		};
		return [ if_statement ];
	}
	
	public static function convert_expression(expression:metahub.code.expressions.Expression, scope:Scope):Dynamic {
		var type = Railway.get_class_name(expression);
		trace("expression:", type);

		switch(type) {
			case "Literal":
				var literal:Literal = cast expression;
				return literal.value;
		}

		throw new Exception("Cannot render expression " + type + ".");
	}
	
}