package metahub.generate.targets;
import metahub.generate.Rail;
import metahub.generate.Railway;
import metahub.generate.Renderer;
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
			class_actions_declaration(rail);
			render.unindent().line("}");

			var body = render.finish();
			var headers = render_headers(rail).finish();

			Utility.create_file(dir + "/" + rail.name + ".cpp", headers + body);
		}
	}

	function ambient_dependencies(rail:Rail) {
		var lines = false;
		for (dependency in rail.dependencies) {
			if (dependency != rail.trellis.parent) {
				render.line('class ' + dependency.name + ";");
				lines = true;
			}
		}

		render.newline();
	}

	function class_declaration(rail:Rail) {
		var first = "class " + rail.name;
		if (rail.trellis.parent != null) {
			first += " : public " + get_rail_class_name(rail.trellis.parent);
			//add_dependency(property.parent);
		}

		render.line(first + " {")
		.line("public:")
		.indent();
		for (property in rail.trellis.core_properties) {
			property_declaration(property);
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

	function get_property_type_string(property:Property) {
		if (property.type == Kind.reference) {
			return get_rail_class_name(property.other_trellis);
		}
		else if (property.type == Kind.list) {
			return "std::vector<" + get_rail_class_name(property.other_trellis) + ">";
		}
		else {
			return Reflect.field(types, property.type.to_string());
		}
	}

	function property_declaration(property:Property) {
		return render.line(get_property_type_string(property) + " " +	property.name + ";");
	}

	function get_rail_class_name(trellis:Trellis) {
		var rail = railway.rails[trellis.name];
		return rail.name;
	}

	function render_headers(rail:Rail) {
		if (rail.trellis.parent != null) {
			render.line('#include "' + rail.trellis.parent.name + '.h"').newline();
		}

		return render;
	}
}