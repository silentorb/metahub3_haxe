package metahub.imperative.types ;
import metahub.imperative.code.Constraint;
import metahub.imperative.schema.Rail;
import metahub.imperative.schema.Railway;
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

	public static function constraint(constraint:Constraint):Array<Statement> {
		var operator = constraint.operator;
		var inverse = Reflect.field(inverse_operators, operator);
		var limit:Float = convert_expression(constraint.expression, constraint.scope).value;

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

		var if_statement:Flow_Control = {
			type: Expression_Type.flow_control,
			name: "if",
			condition: {
				operator: inverse,
				expressions: [
					constraint.reference,
					{ type: Expression_Type.literal, value: limit }
				]
			},
			statements: [
				{
					type: Expression_Type.assignment,
					operator: "=",
					target: constraint.reference,
					expression: { type: Expression_Type.literal, value: value }
				}
			]
		};
		return [ if_statement ];
	}

	public static function convert_expression(expression:metahub.meta.types.Expression, scope:Scope):Expression {
		//trace("expression:", type);

		switch(expression.type) {
			case Expression_Type.literal:
				var literal:metahub.meta.types.Literal = cast expression;
				return {
					type: Expression_Type.literal,
					value: literal.value
				};

			case Expression_Type.function_call:
				var func:metahub.meta.types.Function_Call = cast expression;
				return {
					type: Expression_Type.function_call,
					name: func.name
				};

			default:
				throw new Exception("Cannot convert expression " + expression.type + ".");
		}

	}

	public static function generate_initialize(rail:Rail):Function_Definition {
		var block = new Array<Dynamic>();
		if (rail.parent != null) {
			block.push({
				type: Expression_Type.parent_class,
				child: {
					type: Expression_Type.function_call,
					name: "initialize",
					args: [],
					is_platform_specific: false
				}
			});
		}

		for (tie in rail.all_ties) {
			if (tie.property.type == Kind.list) {
				for (constraint in tie.constraints) {
					block.push(generate_list_constraint(constraint));
				}
			}
		}
		if (rail.hooks.exists("initialize_post")) {
			block.push({
				type: Expression_Type.function_call,
				caller: "this",
				name: "initialize_post",
				args: []
			});
		}

		return {
			type: Expression_Type.function_definition,
			name: 'initialize',
			return_type: { type: Kind.none },
			parameters: [],
			block: block
		};
	}

	public static function generate_list_constraint(constraint:Constraint):Dynamic {
		var reference = constraint.reference.path[0].tie;
		//var amount:Int = target.render_expression(constraint.expression, constraint.scope);
		var expression = convert_expression(constraint.expression, constraint.scope);

		throw "";
		return list_size(constraint, expression);
	}

	public static function list_size(constraint:Constraint, expression:Expression):Flow_Control {
		var instance_name = constraint.reference.path[0].tie.other_rail.rail_name;
		var rail = constraint.reference.path[0].tie.other_rail;

		return {
			type: Expression_Type.flow_control,
			name: "while",
			condition: {
				operator: "<",
				expressions: [
					constraint.reference,
					//{ type: "path", path: constraint.reference },
					expression
				]
			},
			statements: [
				{
					type: Expression_Type.declare_variable,
					name: "_child",
					expression: {
						type: Expression_Type.instantiate,
						rail: rail
					},
					signature: {
						type: Kind.reference,
						rail: rail,
						is_value: false
					}
				},
				{
					type: Expression_Type.variable,
					name: "_child",
					child: {
						type: Expression_Type.function_call,
						name: "initialize",
						is_platform_specific: false,
						args: []
					}
				},
				{
					type: Expression_Type.property,
					tie: constraint.reference.path[0].tie,
					child: {
						type: Expression_Type.function_call,
						name: "add",
						is_platform_specific: true,
						args: [
							{
								type: Expression_Type.variable,
								name: "_child"
							}
						]
					}
				}
			]
		}
	}

}