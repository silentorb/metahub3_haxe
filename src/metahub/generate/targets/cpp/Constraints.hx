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

	public static function render(constraint:Constraint, render:Renderer, target:Cpp):String {
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

	public static function render_list_constraint(constraint:Constraint, render:Renderer, target:Cpp):String {
		//var reference = target.render_value_path(constraint.reference);
		var reference = constraint.reference[0].tie.tie_name;
		var amount:Int = target.render_expression(constraint.expression, constraint.scope);
		var instance_name = constraint.reference[0].tie.other_rail.rail_name;
		return target.render_block('while', reference + '.size() < ' + amount, function() {
			return
				render.line(instance_name + '* _child = new ' + instance_name + '();')
				+ render.line('_child->initialize();')
				+ render.line(reference + '.push_back(*_child);');
		});
	}

}