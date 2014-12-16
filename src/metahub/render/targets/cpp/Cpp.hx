package metahub.render.targets.cpp ;
import haxe.Timer;
import metahub.imperative.schema.Rail;
import metahub.imperative.schema.Railway;
import metahub.imperative.schema.Region;
import metahub.imperative.types.Insert;
import metahub.imperative.types.Null_Value;
import metahub.imperative.types.Path;
import metahub.imperative.types.Variable;
import metahub.meta.types.Literal;
import metahub.imperative.types.Property_Expression;
import metahub.imperative.schema.Tie;
import metahub.Hub;
import metahub.imperative.types.Assignment;
import metahub.imperative.types.Block;
import metahub.imperative.types.Condition;
import metahub.imperative.types.Declare_Variable;
import metahub.imperative.types.Expression;
import metahub.imperative.types.Function_Call;
import metahub.imperative.types.Function_Definition;
import metahub.imperative.types.Flow_Control;
import metahub.imperative.types.Instantiate;
import metahub.imperative.types.Parameter;
import metahub.imperative.types.Scope;
import metahub.imperative.types.Signature;
import metahub.imperative.types.Statement;
import metahub.schema.Namespace;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.imperative.types.Expression_Type;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Cpp extends Target{

	var current_region:Region;
	var current_rail:Rail;
	var scopes = new Array<Map<String, Signature>>();
	var current_scope:Map<String, Signature>;

	static var types = {
		"string": "std::string",
		"int": "int",
		"bool": "bool",
		"float": "float",
		"none": "void"
	}

	public function new(railway:Railway) {
		super(railway);
	}

	override public function run(output_folder:String) {
		for (region in railway.regions){
			for (rail in region.rails) {
				if (rail.is_external)
					continue;

				//trace(rail.namespace.fullname);
				var namespace = Generator.get_namespace_path(rail.region);
				var dir = output_folder + "/" + namespace.join('/');
				Utility.create_folder(dir);

				line_count = 0;
				create_header_file(rail, namespace, dir);
				create_class_file(rail, namespace, dir);
			}
		}
	}

	override function generate_rail_code(rail:Rail) {
		var root = rail.get_block("/");
		var references = new Array<Tie>();
		for (tie in rail.core_ties) {
			if (tie.type == Kind.reference && !tie.is_value)
				references.push(tie);
		}

		var func = new Function_Definition(rail.rail_name, rail, [],
			cast references.map(function(tie) return new Assignment(
				new Property_Expression(tie), "=", new Null_Value())
			)
		);
		func.return_type = null;
		root.push(func);
		func = new Function_Definition("~" + rail.rail_name, rail, [],
		[]	//cast references.map(function(tie) return new Function_Call("SAFE_DELETE",
				//[new Property_Expression(tie)])
			//)
		);
		func.return_type = null;
		root.push(func);
	}

	function push_scope() {
		current_scope = new Map<String, Signature>();
		scopes.push(current_scope);
	}

	function pop_scope() {
		scopes.pop();
		current_scope = scopes[scopes.length - 1];
	}

	function create_header_file(rail:Rail, namespace, dir) {
		var headers = [ "stdafx" ];

		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (!d.allow_ambient)
				headers.push(dependency.source_file);
		}

		render = new Renderer();
		var result = line('#pragma once')
		+ render_includes(headers) + newline()
		+ render_outer_dependencies(rail)
		+ render_region(rail.region, function() {
			return newline() + render_inner_dependencies(rail) + class_declaration(rail);
		});
		Utility.create_file(dir + "/" + rail.name + ".h", result);
	}

	function create_class_file(rail:Rail, namespace, dir) {
		scopes = [];
		var headers = [ "stdafx", rail.source_file ];
		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (dependency != rail.parent && dependency.source_file != null) {
				headers.push(dependency.source_file);
			}
		}
		render = new Renderer();
		var result = render_includes(headers) + newline()
		+ render_statements(rail.code.statements);

		Utility.create_file(dir + "/" + rail.name + ".cpp", result);
	}

	function render_statements(statements:Array<Dynamic>, glue = ""):String {
		return statements.map(function(s) return render_statement(s)).join(glue);
	}

	function render_statement(statement:Dynamic) {
		var type:Expression_Type = statement.type;
		switch(type) {
			case Expression_Type.namespace:
				return render_region(statement.region, function() {
					return render_statements(statement.expressions);
				});

			case Expression_Type.class_definition:
				return class_definition(statement.rail, statement.expressions);

			case Expression_Type.function_definition:
				return render_function_definition(statement);

			case Expression_Type.flow_control:
				return render_if(statement);

			case Expression_Type.function_call:
				return line(render_function_call(statement, null) + ";");

			case Expression_Type.assignment:
				return render_assignment(statement);

			case Expression_Type.declare_variable:
				return render_variable_declaration(statement);

			case Expression_Type.statement:
				var s:Statement = cast statement;
				return line(s.name + ";");

			case Expression_Type.insert:
				var insert:Insert = cast statement;
				return line(insert.code);

			default:
				return line(render_expression(statement) + ";");
				//throw new Exception("Unsupported statement type: " + statement.type + ".");
		}
	}

	function render_variable_declaration(declaration:Declare_Variable):String {
		var first = render_signature(declaration.signature) + " " + declaration.name;
		if (declaration.expression != null)
			first += " = " + render_expression(declaration.expression);

		current_scope[declaration.name] = declaration.signature;
		return line(first + ";");
	}

	function render_outer_dependencies(rail:Rail):String {
		var lines = false;
		var result = "";
		var regions = new Map<String, {region:Region, dependencies:Array<Rail>}>();

		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (d.allow_ambient && dependency.region != rail.region) {
				if (!regions.exists(dependency.region.name)) {
					regions[dependency.region.name] = {
						region: dependency.region,
						dependencies: []
					}
				}
				regions[dependency.region.name].dependencies.push(dependency);
				lines = true;
			}
		}

		for (r in regions) {
			result += render_region(r.region, function()
				return r.dependencies.map(function(d)
					return line("class " + d.rail_name + ";"))
					.join("")
			);
		}

		if (result.length > 0)
			result += newline();

		return result;
	}

	function render_inner_dependencies(rail:Rail):String {
		var lines = false;
		var result = "";
		for (d in rail.dependencies) {
			var dependency = d.rail;
			if (d.allow_ambient && dependency.region == rail.region) {
				result += line('class ' + get_rail_type_string(dependency) + ";");
				lines = true;
			}
		}

		if (result.length > 0)
			result += newline();

		return result;
	}

	function class_declaration(rail:Rail):String {
		current_rail = rail;
		var result = "";
		var first = "class ";
		if (rail.class_export.length > 0)
			first += rail.class_export + " ";

		first += rail.rail_name;
		if (rail.trellis.parent != null) {
			first += " : public " + render_rail_name(rail.parent);
		}

		result = line(first + " {")
		+ "public:" + newline();
		indent();

		for (tie in rail.core_ties) {
			result += property_declaration(tie);
		}

		result += pad(render_function_declarations(rail))
		+ unindent().line("};");

		current_rail = null;
		return result;
	}

	function class_definition(rail:Rail, statements:Array<Dynamic>):String {
		current_rail = rail;
		var result = "";

		//result += pad(render_functions(rail));
		result += newline() + render_statements(statements, newline());
		unindent();

		current_rail = null;
		return result;
	}

	function render_region(region:Region, action) {
		var namespace = Generator.get_namespace_path(region);
		var result = line("namespace " + namespace.join('::') + " {");
		current_region = region;
		indent();
		result += action()
		+ unindent().line("}");

		current_region = null;
		return result;
	}

	//function render_functions(rail:Rail):String {
		//var result = "";
		//var definitions = [ render_initialize_definition(rail) ];
//
		////for (tie in rail.all_ties) {
			////var definition = render_setter(tie);
			////if (definition.length > 0)
				////definitions.push(definition);
		////}
////
		//return definitions.join(newline());
	//}

	function render_rail_name(rail:Rail):String {
		if (rail.region != current_region)
			return render_region_name(rail.region) + "::" + rail.rail_name;

		return rail.rail_name;
	}

	function render_region_name(region:Region):String {
		var path = Generator.get_namespace_path(region);
		return path.join("::");
	}

	function render_function_definition(definition:Function_Definition):String {
		var intro = (definition.return_type != null ? render_signature(definition.return_type) + " " : "")
		+ current_rail.rail_name + '::' + definition.name
		+ "(" + definition.parameters.map(render_parameter).join(", ") + ")";

		return render_scope(intro, function() {
			for (parameter in definition.parameters) {
				current_scope[parameter.name] = parameter.signature;
			}

		  return render_statements(definition.block);
		});
	}

	function render_parameter(parameter:Parameter):String {
		return render_signature(parameter.signature, true) + ' ' + parameter.name;
	}

	function render_function_declarations(rail:Rail):String {
		var declarations = [ ]
			.concat(rail.stubs.map(function(s) return line(s)));

		if (rail.hooks.exists("initialize_post")) {
			declarations.push(line("void initialize_post(); // Externally defined."));
		}

		for (tie in rail.all_ties) {
			if (tie.has_set_post_hook)
				declarations.push(line("void " + tie.get_setter_post_name() + "(" + get_property_type_string(tie, true) +  " value);"));
		}

		//for (tie in rail.all_ties) {
			//if (tie.has_setter())
				//declarations.push(line(render_signature_old('set_' + tie.tie_name, tie) + ';'));
		//}

		for (func in rail.functions) {
			declarations.push(render_function_declaration(func));
		}

		return declarations.join('');
	}

	//function render_initialize_definition(rail:Rail):String {
		//var result = line("void " + rail.rail_name + "::initialize() {");
		//indent();
		//result += line(rail.parent != null
			//? rail.parent.rail_name + "::initialize();"
			//: ""
		//);
		//for (tie in rail.all_ties) {
			//if (tie.property.type == Kind.list) {
				//for (constraint in tie.constraints) {
					//result += Constraints.render_list_constraint(constraint, render, this);
				//}
			//}
		//}
		//if (rail.hooks.exists("initialize_post")) {
			//result += line("initialize_post();");
		//}
		//unindent();
		//return result + line("}");
	//}

	function get_rail_type_string(rail:Rail):String {
		var name = rail.rail_name;
		if (rail.region.external_name != null)
			name = rail.region.external_name + "::" + name;
		else if (rail.region != current_region)
			name = rail.region.name + "::" + name;

		return name;
	}

	function get_property_type_string(tie:Tie, is_parameter = false) {
		var other_rail = tie.other_rail;
		if (other_rail == null)
			return Reflect.field(types, tie.property.type.to_string());

		var other_name = get_rail_type_string(other_rail);
		if (tie.property.type == Kind.reference) {
			return
			tie.is_value ? is_parameter ? other_name + '&' : other_name :
					other_name + '*';
		}
		else {
			return "std::vector<" + other_name + ">";
		}
	}

	function property_declaration(tie:Tie):String {
		return line(get_property_type_string(tie) + " " +	tie.tie_name + ";");
	}

	function render_includes(headers:Array<String>):String {
		return headers.map(function(h) return line('#include "' + h + '.h"')).join('');
	}

	function render_signature_old(name, tie:Tie):String {
		var right = name + '(' + get_property_type_string(tie, true) + ' value)';
		return 'void ' + right;
	}

	function render_function_declaration(definition:Function_Definition):String {
		return line((definition.return_type != null ? "virtual " : "")
		+ (definition.return_type != null ? render_signature(definition.return_type) + " " : "")
		+ definition.name
		+ "(" + definition.parameters.map(render_parameter).join(", ") + ");");

	}

	function render_signature(signature:Signature, is_parameter = false):String {
		if (signature.rail == null) {
			return signature.type == Kind.reference
				? "void*"
				: Reflect.field(types, signature.type.to_string());
		}

		var name = get_rail_type_string(signature.rail);
		if (signature.type == Kind.reference) {
			return
			signature.is_value ? is_parameter ? name + '&' : name :
					name + '*';
		}
		else {
			return "std::vector<" + name + ">";
		}
	}

	public function render_block(command:String, expression:String, action):String {
		var result = line(command + ' (' + expression + ') {');
		indent();
		result += action();
		unindent();
		result += line('}');
		return result;
	}

	public function render_scope(intro:String, action):String {
		push_scope();
		var result = line(intro + ' {');
		indent();
		result += action();
		unindent();
		result += line('}');
		pop_scope();
		return result;
	}

	public function render_scope2(intro:String, statements:Array<Dynamic>, minimal = false):String {
		indent();
		var lines = line_count;
		var block = render_statements(statements);
		unindent();

		if (minimal) {
			minimal = line_count == lines + 1;
		}
		var result = line(intro + (minimal ? '' : ' {'));
		result += block;
		result += line((minimal ? '' : '}'));
		return result;
	}

	//function render_setter(tie:Tie):String {
		//if (!tie.has_setter())
			//return "";

		//var result = line(render_signature_old('set_' + tie.tie_name, tie) + ' {');
		//indent();
		//for (constraint in tie.constraints) {
			//result += Constraints.render(constraint, render, this);
		//}
		//result +=
			//line('if (' + tie.tie_name + ' == value)')
		//+ indent().line('return;')
		//+	unindent().newline()
		//+ line(tie.tie_name + ' = value;');
		//if (tie.has_set_post_hook)
			//result += line(tie.get_setter_post_name() + "(value);");
//
		//unindent();
		//result += line('}');
		//return result;
	//}

	function render_path(path:Array<Tie>):String {
		return path.map(function(t) return t.tie_name).join('->');
	}

	//function render_function_call(statement:Function_Call):String {
		//return line(statement.name + "();");
	//}

	function render_if(statement:Flow_Control):String {
		return render_scope2(
			statement.name + " (" + render_condition(statement.condition) + ")"
		, statement.children, statement.name == "if");
	}

	function render_condition(condition:Condition):String {
		return condition.expressions.map(function (c) return render_expression(c)).join(' ' + condition.operator + ' ');
	}

	function render_expression(expression:Expression, parent:Expression = null):String {
		var result:String;
		switch(expression.type) {
			case Expression_Type.literal:
				var literal:Literal = cast expression;
				result = Std.string(literal.value);

			case Expression_Type.path:
				result = render_path_old(cast expression);

			case Expression_Type.property:
				var property_expression:Property_Expression = cast expression;
				result = property_expression.tie.tie_name;

			case Expression_Type.function_call:
				result = render_function_call(cast expression, parent);

			case Expression_Type.instantiate:
				result = render_instantiation(cast expression);

			case Expression_Type.self:
				result = "this";

			case Expression_Type.null_value:
				return "NULL";

			case Expression_Type.variable:
				var variable_expression:Variable = cast expression;
				if (find_variable(variable_expression.name) == null)
					throw new Exception("Could not find variable: " + variable_expression.name + ".");

				result = variable_expression.name;

			case Expression_Type.parent_class:
				result = current_rail.parent.rail_name;

			default:
				throw new Exception("Unsupported expression type: " + expression.type + ".");
		}

		if (expression.child != null) {
			result += get_connector(expression) + render_expression(expression.child, expression);
		}

		return result;
	}

	function get_signature(expression:Expression):Dynamic {
		switch (expression.type) {
			case Expression_Type.variable:
				var variable_expression:Variable = cast expression;
				return find_variable(variable_expression.name);

			case Expression_Type.property:
				var property_expression:Property_Expression = cast expression;
				return property_expression.tie;

			default:
				throw new Exception("Determining pointer is not yet implemented for expression type: " + expression.type + ".");
		}
	}

	function is_pointer(signature:Dynamic):Bool {
		if (signature.type == null)
			throw "";
		return !signature.is_value && signature.type != Kind.list;
	}

	function get_connector(expression:Expression) {
		if (expression.type == Expression_Type.parent_class)
			return "::";

		return is_pointer(get_signature(expression)) ? "->" : ".";
	}

	function find_variable(name:String):Signature {
		var i = scopes.length;
		while (--i >= 0) {
			if (scopes[i].exists(name))
				return scopes[i][name];
		}

		return null;
	}

	function render_instantiation(expression:Instantiate):String {
		return "new " + get_rail_type_string(expression.rail) + "()";
	}

	function render_function_call(expression:Function_Call, parent:Expression):String {
		if (expression.is_platform_specific) {
			//var args = expression.args.map(function(a) return a).join(", ");

			switch (expression.name) {
				case "count":
					return "size()";

				case "add":
					var first = expression.args[0].name;
					var dereference = is_pointer(find_variable(first)) ? "*" : "";
					return "push_back(" + dereference + first + ")";

				default:
					throw new Exception("Unsupported platform-specific function: " + expression.name + ".");
			}
		}

		return expression.name + "(" +
			expression.args.map(function(a) return render_expression(a))
			.join(", ") + ")";
	}

	function render_path_old(expression:Path) {
		var parent:Expression = null;
		var result = "";
		for (child in expression.children) {
			if (parent != null)
				result += get_connector(parent);

			result += render_expression(child, parent);
			parent = child;
		}

		return result;
	}

	function render_assignment(statement:Assignment):String {
		return line(render_expression(statement.target) + ' ' + statement.operator + ' ' + render_expression(statement.expression) + ';');
	}

	//public function render_expression(expression:Expression, scope:Scope):Dynamic {
		//var type = Railway.get_class_name(expression);
		//trace("expression:", type);
//
		//switch(type) {
			//case "Literal":
				//return render_literal(cast expression);
		//}
//
		//throw new Exception("Cannot render expression " + type + ".");
	//}
//
	//function render_literal(expression:Literal):String {
		//return expression.value;
	//}
}