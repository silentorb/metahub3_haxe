package metahub.generate.targets;
import metahub.generate.Rail;
import metahub.generate.Railway;
import metahub.generate.Renderer;
import metahub.generate.Tie;
import metahub.Hub;
import metahub.schema.Namespace;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Cpp_Target extends Target{

	//var types:Map<Kind, Dynamic>;

	static var types = {
		"string": "std::string",
		"int": "int",
		"bool": "bool",
		"float": "float"
	}

	static var operators = {
		"greater_than": ">",
		"lesser_than": "<"
	}

	public function new(railway:Railway) {
		super(railway);

		//types[Kind.string] = {
			//symbol: "std::string",
			//default_value:
		//}
	}

	override public function run(statement, output_folder:String) {
		for (rail in railway.rails) {
			//trace(rail.namespace.fullname);
			render = new Renderer();
			var namespace = Generator.get_namespace_path(rail.trellis.namespace);
			var dir = output_folder + "/" + namespace.join('/');
			Utility.create_folder(dir);

			render.line("namespace " + namespace.join('.') + " {")
			.indent().newline();
			ambient_dependencies(rail);
			class_declaration(rail);
			render.newline();
			//class_actions_declaration(rail);
			render.unindent().line("}");

			var body = render.finish();
			var headers = render_headers(rail).finish();

			Utility.create_file(dir + "/" + rail.name + ".cpp", headers + body);
		}
	}

	function ambient_dependencies(rail:Rail) {
		var lines = false;
		for (dependency in rail.dependencies) {
			if (dependency != rail.parent) {
				render.line('class ' + dependency.rail_name + ";");
				lines = true;
			}
		}

		render.newline();
	}

	function class_declaration(rail:Rail) {
		var first = "class " + rail.name;
		if (rail.trellis.parent != null) {
			first += " : public " + rail.parent.rail_name;
		}

		render.line(first + " {")
		.line("public:")
		.indent();
		for (tie in rail.core_ties) {
			property_declaration(tie);
		}

		for (tie in rail.all_ties) {
			render_setter(tie);
		}

		render.unindent().line("}")
		;
	}

	function class_actions_declaration(rail:Rail) {
		return render.line("class " + rail.name + "_Actions {")
		.newline()
		.line("}")
		;
	}

	function get_property_type_string(tie:Tie, is_parameter = false) {
		if (tie.property.type == Kind.reference) {
			return is_parameter
			? tie.other_rail.rail_name + '&'
			: tie.other_rail.rail_name;
		}
		else if (tie.property.type == Kind.list) {
			return "std::vector<" + tie.other_rail.rail_name + ">";
		}
		else {
			return Reflect.field(types, tie.property.type.to_string());
		}
	}

	function property_declaration(tie:Tie) {
		return render.line(get_property_type_string(tie) + " " +	tie.tie_name + ";");
	}

	function render_headers(rail:Rail) {
		if (rail.trellis.parent != null) {
			render.line('#include "' + rail.trellis.parent.name + '.h"').newline();
		}

		return render;
	}

	function render_setter(tie:Tie) {
		if (tie.constraints.length == 0)
			return;

		render.line('function set_' + tie.tie_name + '(' + get_property_type_string(tie, true) + ' value) {');
		render.indent();
		for (constraint in tie.constraints) {
			render.line('if (' + render_value_path(constraint.reference)
			+ ' ' + Reflect.field(operators, constraint.operator) + ' '
			+ ')');
		}
		render.unindent();
		render.line('}');
	}

	function render_value_path(path:Array<Tie>) {
		return ['value'].concat(path.slice(1).map(function(t) return t.tie_name)).join('.');
	}

	function render_path(path:Array<Tie>) {
		return path.map(function(t) return t.tie_name).join('.');
		//var result = "";
		//for (tie in path) {
			////token.
		//}
//
		//return result;
	}
}