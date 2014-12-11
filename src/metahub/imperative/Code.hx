package metahub.imperative;
import metahub.code.expressions.Literal;
import metahub.code.Scope;
import metahub.generate.Constraint;
import metahub.generate.Rail;
import metahub.generate.Railway;
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
			type: "flow_control",
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
					type: "assignment",
					operator: "=",
					target: constraint.reference,
					expression: { type: Expression_Type.literal, value: value }
				}
			]
		};
		return [ if_statement ];
	}

	public static function convert_expression(expression:metahub.code.expressions.Expression, scope:Scope):Expression {
		var type = Railway.get_class_name(expression);
		trace("expression:", type);

		switch(type) {
			case "Literal":
				var literal:Literal = cast expression;
				return { type: Expression_Type.literal, value: literal.value };
		}

		throw new Exception("Cannot convert expression " + type + ".");
	}

	public static function generate_initialize(rail:Rail):Function_Definition {
		var block = new Array<Dynamic>();

		for (tie in rail.all_ties) {
			if (tie.property.type == Kind.list) {
				for (constraint in tie.constraints) {
					block.push(generate_list_constraint(constraint));
				}
			}
		}
		if (rail.hooks.exists("initialize_post")) {
			block.push({
				type: "function_call",
				caller: "this",
				name: "initialize_post",
				args: []
			});
		}

		return {
			type: "function_definition",
			name: 'initialize',
			return_type: { type: Kind.none },
			parameters: [],
			block: block
		};
	}

	public static function generate_list_constraint(constraint:Constraint):Flow_Control {
		var reference = constraint.reference.path[0].tie;
		//var amount:Int = target.render_expression(constraint.expression, constraint.scope);
		var instance_name = constraint.reference.path[0].tie.other_rail.rail_name;
		return {
			type: "flow_control",
			name: "while",
			condition: {
				operator: "<",
				expressions: [
					constraint.reference,
					//{ type: "path", path: constraint.reference },
					convert_expression(constraint.expression, constraint.scope)
				]
			},
			statements: [

			]
		}
		//return target.render_block('while', reference + '.size() < ' + amount, function() {
			//return
				//render.line(instance_name + '* _child = new ' + instance_name + '();')
				//+ render.line('_child->initialize();')
				//+ render.line(reference + '.push_back(*_child);');
		//});
	}

}