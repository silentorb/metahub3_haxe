package metahub.generate.targets.cpp ;
import haxe.Timer;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Literal;
import metahub.code.Scope;
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
	public var map:Dynamic;

	static var types = {
		"string": "std::string",
		"int": "int",
		"bool": "bool",
		"float": "float"
	}

	//public static var operators = {
		//"greater_than": ">",
		//"lesser_than": "<",
		//"greater_than_or_equal_to": ">=",
		//"lesser_than_or_equal_to": "<="
	//}
//
	public function new(railway:Railway, map:Dynamic) {
		this.map = map != null ? map : {};
		super(railway);

		//types[Kind.string] = {
			//symbol: "std::string",
			//default_value:
		//}
	}

	override public function run(statement, output_folder:String) {
		for (rail in railway.rails) {
			//trace(rail.namespace.fullname);
			var namespace = Generator.get_namespace_path(rail.trellis.namespace);
			var dir = output_folder + "/" + namespace.join('/');
			Utility.create_folder(dir);

			create_header_file(rail, namespace, dir);
			create_class_file(rail, namespace, dir);
		}
	}

	function create_header_file(rail:Rail, namespace, dir) {
		var headers = [ "stdafx" ];
		if (rail.trellis.parent != null)
			headers.push(rail.trellis.parent.name);

		render = new Renderer();
		var result = render.line('#pragma once')
		+ render_includes(headers) + render.newline()
		+ render.line("namespace " + namespace.join('.') + " {")
		+ render.indent().newline()
		+ ambient_dependencies(rail)
		+ class_declaration(rail)
		+ render.newline()
		+ render.unindent().line("}");
		Utility.create_file(dir + "/" + rail.name + ".h", result);
	}

	function create_class_file(rail:Rail, namespace, dir) {
		var headers = [ "stdafx", rail.rail_name ];
		render = new Renderer();
		var result = render_includes(headers) + render.newline()
		+ render.line("namespace " + namespace.join('.') + " {");
		render.indent();
		result += class_definition(rail)
		+ render.newline()
		+ render.unindent().line("}");
		Utility.create_file(dir + "/" + rail.name + ".cpp", result);
	}

	function ambient_dependencies(rail:Rail):String {
		var lines = false;
		var result = "";
		for (dependency in rail.dependencies) {
			if (dependency != rail.parent) {
				result += render.line('class ' + dependency.rail_name + ";");
				lines = true;
			}
		}

		return result + render.newline();
	}

	function class_declaration(rail:Rail):String {
		var result = "";
		var first = "class " + rail.name;
		if (rail.trellis.parent != null) {
			first += " : public " + rail.parent.rail_name;
		}

		result = render.line(first + " {")
		+ render.line("public:");
		render.indent();

		for (tie in rail.core_ties) {
			result += property_declaration(tie);
		}

		result += render.pad(render_function_declarations(rail))
		+ render.unindent().line("};");

		return result;
	}

	function class_definition(rail:Rail):String {
		var result = "";

		result += render.pad(render_functions(rail));
		render.unindent();

		return result;
	}

	function render_functions(rail:Rail):String {
		var result = "";
		for (tie in rail.all_ties) {
			result += render_setter(tie);
		}

		return result;
	}

	function render_function_declarations(rail:Rail):String {
		var result = "";
		for (tie in rail.all_ties) {
			if (tie.constraints.length > 0)
				result += render.line(render_signature('set_', tie) + ';');
		}

		return result;
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

	function property_declaration(tie:Tie):String {
		return render.line(get_property_type_string(tie) + " " +	tie.tie_name + ";");
	}

	function render_includes(headers:Array<String>):String {
		return headers.map(function(h) return render.line('#include "' + h + '.h"')).join('');
	}

	function render_signature(prefix, tie:Tie, is_definition = false):String {
		var right = 'set_' + tie.tie_name + '(' + get_property_type_string(tie, true) + ' value)';
		if (is_definition)
			right = tie.rail.rail_name + "::" + right;

		return 'void ' + right;
	}

	function render_setter(tie:Tie):String {
		if (tie.constraints.length == 0)
			return "";

		var result = render.line(render_signature('set_', tie, true) + ' {');
		render.indent();
		for (constraint in tie.constraints) {
			result += Constraints.render(constraint, render, this);
		}
		result +=
			render.line('if (' + tie.tie_name + ' == value)')
		+ render.indent().line('return;')
		+	render.unindent().newline()
		+ render.line(tie.tie_name + ' = value;');
		render.unindent();
		result += render.line('}');
		return result;
	}

	public function render_value_path(path:Array<Tie>):String {
		return ['value'].concat(path.slice(1).map(function(t) return t.tie_name)).join('.');
	}

	function render_path(path:Array<Tie>):String {
		return path.map(function(t) return t.tie_name).join('.');
	}

	public function render_expression(expression:Expression, scope:Scope):Dynamic {
		var type = Railway.get_class_name(expression);
		trace("expression:", type);

		switch(type) {
			case "Literal":
				return render_literal(cast expression);
		}

		throw new Exception("Cannot render expression " + type + ".");
	}

	function render_literal(expression:Literal):String {
		return expression.value;
	}
}