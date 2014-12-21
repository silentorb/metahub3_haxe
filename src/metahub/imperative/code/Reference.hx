package metahub.imperative.code ;
import metahub.imperative.Imp;
import metahub.logic.schema.Constraint;
import metahub.logic.schema.Rail;
import metahub.logic.schema.Railway;
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

	public static function constraint(constraint:Constraint, imp:Imp):Array<Expression> {
		var operator = constraint.operator;
		var reference = imp.translate(constraint.reference);
		
		if (operator == "in") {
			var args:metahub.meta.types.Block = cast constraint.expression;
			return generate_constraint(reference, ">=", cast args.children[0])
			.concat(
				generate_constraint(reference, "<=", cast args.children[1])
			);
		}
		
		return generate_constraint(reference, constraint.operator, cast constraint.expression);
		//var inverse = Reflect.field(inverse_operators, operator);
		//var conversion:Literal = cast constraint.expression;
		//var limit:Float = conversion.value;
//
		//var min:Float = 0.0001;
		//var value:Float = 0;
		//switch(operator) {
			//case '<':
				//value = limit - min;
			//case '>':
				//value = limit + min;
			//case '<=':
				//value = limit;
			//case '>=':
				//value = limit;
		//}
//
		//return [ new Flow_Control("if",	new Condition(inverse,
				//[
					//imp.translate(constraint.reference),
					//{ type: Expression_Type.literal, value: limit }
				//]
			//),
			//[
				//new Assignment(imp.translate(constraint.reference), "=", new Literal(value, { type: Kind.float }))
			//]
		//)];
	}
	
	static function generate_constraint(reference:Expression, operator, literal:Literal):Array<Expression> {
		var inverse = Reflect.field(inverse_operators, operator);
		var limit:Float = literal.value;

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
					reference,
					{ type: Expression_Type.literal, value: limit }
				]
			),
			[
				new Assignment(reference, "=", new Literal(value, { type: Kind.float }))
			]
		)];
	}

	//public static function convert_expression(expression:metahub.meta.types.Expression, scope:Scope):Expression {
//
		//
//
	//}

}