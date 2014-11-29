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
		switch(operator) {
			case '<':
				result += render.line(reference + ' = ' + Std.string(limit - min));
			case '>':
				result += render.line(reference + ' = ' + Std.string(limit + min));
			case '<=':
				result += render.line(reference + ' = ' + Std.string(limit));
			case '>=':
				result += render.line(reference + ' = ' + Std.string(limit));
		}
		render.unindent();
		return result + render.newline();
	}
	
}