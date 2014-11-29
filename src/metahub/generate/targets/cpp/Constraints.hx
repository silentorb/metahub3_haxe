package metahub.generate.targets.cpp;
import metahub.generate.Constraint;
import metahub.generate.Renderer;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraints
{

	public static var inverse_operators = {
		">": "<=",
		"<": ">=",
		">=": "<",
		"<=": ">"
	}

	public static function render(constraint:Constraint, render:Renderer, target:Cpp_Target):String {
		var operator = constraint.operator;
		var inverse = Reflect.field(inverse_operators, operator);
		var reference = target.render_value_path(constraint.reference);
		var limit:Float = target.render_expression(constraint.expression, constraint.scope);
		var result = render.line('if (' + reference
			+ ' ' + inverse + ' '
			+ Std.string(limit)
			+ ')'
		);

		var min:Float = 0.0001;
		render.indent();
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
		result += render.line(reference + ' = ' + Std.string(value) + ';');
		render.unindent();
		return result + render.newline();
	}

}