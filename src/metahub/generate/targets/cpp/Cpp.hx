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
class Cpp extends Target{

	static var types = {
		"string": "std::string",
		"int": "int",
		"bool": "bool",
		"float": "float"
	}

	public function new(railway:Railway) {
		super(railway);
	}

	override public function run(statement, output_folder:String) {
		for (region in railway.regions){
			for (rail in region.rails) {
				if (rail.is_external)
					continue;

				//trace(rail.namespace.fullname);
				var namespace = Generator.get_namespace_path(rail.trellis.namespace);
				var dir = output_folder + "/" + namespace.join('/');
				Utility.create_folder(dir);

				create_header_file(rail, namespace, dir);
				create_class_file(rail, namespace, dir);
			}
		}
	}

	function create_header_file(rail:Rail, namespace, dir) {
		var headers = [ "stdafx" ];
		//if (rail.parent != null && rail.parent.source_file != null)
			//headers.push(rail.parent.source_file);

		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (!d.allow_ambient)
				headers.push(dependency.source_file);
		}

		render = new Renderer();
		var result = render.line('#pragma once')
		+ render_includes(headers) + render.newline()
		+ render.line("namespace " + namespace.join('.') + " {")
		+ render.indent().newline()
		+ render_ambient_dependencies(rail)
		+ class_declaration(rail)
		+ render.newline()
		+ render.unindent().line("}");
		Utility.create_file(dir + "/" + rail.name + ".h", result);
	}

	function create_class_file(rail:Rail, namespace, dir) {
		var headers = [ "stdafx", rail.source_file ];
		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (dependency != rail.parent && dependency.source_file != null) {
				headers.push(dependency.source_file);
			}
		}
		render = new Renderer();
		var result = render_includes(headers) + render.newline()
		+ render.line("namespace " + namespace.join('.') + " {");
		render.indent();
		result += class_definition(rail)
		+ render.newline()
		+ render.unindent().line("}");
		Utility.create_file(dir + "/" + rail.name + ".cpp", result);
	}

	function render_ambient_dependencies(rail:Rail):String {
		var lines = false;
		var result = "";
		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (d.allow_ambient) {
				result += render.line('class ' + get_rail_type_string(dependency) + ";");
				lines = true;
			}
		}

		if (result.length > 0)
			result += render.newline();

		return result;
	}

	function class_declaration(rail:Rail):String {
		var result = "";
		var first = "class ";
		if (rail.class_export.length > 0)
			first += rail.class_export + " ";
		
		first += rail.rail_name;
		if (rail.trellis.parent != null) {
			first += " : public " + rail.parent.rail_name;
		}

		result = render.line(first + " {")
		+ "public:" + render.newline();
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
		var definitions = [ render_initialize_definition(rail) ];

		for (tie in rail.all_ties) {
			var definition = render_setter(tie);
			if (definition.length > 0)
				definitions.push(definition);
		}

		return definitions.join(render.newline());
	}

	function render_function_declarations(rail:Rail):String {
		var declarations = [ render.line("virtual void initialize();") ]
			.concat(rail.stubs.map(function(s) return render.line(s)));

		if (rail.hooks.exists("initialize_post")) {
			declarations.push(render.line("void initialize_post(); // Externally defined."));
		}

		for (tie in rail.all_ties) {
			if (tie.has_set_post_hook)
				declarations.push(render.line("void " + tie.get_setter_post_name() + "(" + get_property_type_string(tie, true) +  " value);"));
		}

		for (tie in rail.all_ties) {
			if (tie.has_setter())
				declarations.push(render.line(render_signature('set_' + tie.tie_name, tie) + ';'));
		}

		return declarations.join('');
	}

	function render_initialize_definition(rail:Rail):String {
		var result = render.line("void " + rail.rail_name + "::initialize() {");
		render.indent();
		result += render.line(rail.parent != null
			? rail.parent.rail_name + "::initialize();"
			: ""
		);
		for (tie in rail.all_ties) {
			if (tie.property.type == Kind.list) {
				for (constraint in tie.constraints) {
					result += Constraints.render_list_constraint(constraint, render, this);
				}
			}
		}
		if (rail.hooks.exists("initialize_post")) {
			result += render.line("initialize_post();");
		}
		render.unindent();
		return result + render.line("}");
	}

	function get_rail_type_string(rail:Rail):String {
		var name = rail.rail_name;
		if (rail.region.external_name != null)
			name = rail.region.external_name + "::" + name;

		return name;
	}

	function get_property_type_string(tie:Tie, is_parameter = false) {
		var other_rail = tie.other_rail;
		if (other_rail == null)
			return Reflect.field(types, tie.property.type.to_string());

		var other_name = get_rail_type_string(other_rail);
		if (tie.property.type == Kind.reference) {
			return tie.is_value
				? is_parameter ? other_name + '&' : other_name
				: other_name + '*';
		}
		else {
			return "std::vector<" + other_name + ">";
		}
	}

	function property_declaration(tie:Tie):String {
		return render.line(get_property_type_string(tie) + " " +	tie.tie_name + ";");
	}

	function render_includes(headers:Array<String>):String {
		return headers.map(function(h) return render.line('#include "' + h + '.h"')).join('');
	}

	function render_signature(name, tie:Tie, is_definition = false):String {
		var right = name + '(' + get_property_type_string(tie, true) + ' value)';
		if (is_definition)
			right = tie.rail.rail_name + "::" + right;

		return 'void ' + right;
	}

	public function render_block(command:String, expression:String, action):String {
		var result = render.line(command + ' (' + expression + ') {');
		render.indent();
		result += action();
		render.unindent();
		result += render.line('}');
		return result;
	}

	function render_setter(tie:Tie):String {
		if (!tie.has_setter())
			return "";

		var result = render.line(render_signature('set_' + tie.tie_name, tie, true) + ' {');
		render.indent();
		for (constraint in tie.constraints) {
			result += Constraints.render(constraint, render, this);
		}
		result +=
			render.line('if (' + tie.tie_name + ' == value)')
		+ render.indent().line('return;')
		+	render.unindent().newline()
		+ render.line(tie.tie_name + ' = value;');
		if (tie.has_set_post_hook)
			result += render.line(tie.get_setter_post_name() + "(value);");

		render.unindent();
		result += render.line('}');
		return result;
	}

	public function render_value_path(path:Array<Car>):String {
		return ['value'].concat(path.slice(1).map(function(t) return render_car(t))).join('.');
	}

	public function render_car(car:Car):String {
		if (car.tie != null)
			return car.tie.tie_name;

		return car.func.function_string;
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