package metahub.code;
import metahub.code.expressions.Scope_Expression;
import metahub.code.Reference;
import metahub.engine.Constraint_Operator;
import metahub.Hub;
import metahub.schema.Kind;
import metahub.schema.Namespace;
import metahub.schema.Property;
import metahub.code.expressions.*;
import metahub.schema.Trellis;
import metahub.code.references.*;
import metahub.code.symbols.*;
import metahub.code.functions.Functions;
import metahub.code.statements.*;
import metahub.code.Scope_Definition;

typedef Conditions_Source = {
	type:String,
	conditions:Array<Dynamic>,
	mode:String
}

class Coder {
  var hub:Hub;

  public function new(hub:Hub) {
    this.hub = hub;
  }

  public function convert_expression(source:Dynamic, scope_definition:Scope_Definition):Expression {

    switch(source.type) {
			case 'block':
        return create_block(source, scope_definition);
      case 'literal':
        return create_literal(source, scope_definition);
      case 'path':
        return create_path(source, scope_definition);
			//case 'reference':
        //return create_general_reference(source, scope_definition);
      case 'function':
        return function_expression(source, scope_definition, source.name);
			case 'create_node':
        return create_node(source, scope_definition);
			case 'conditions':
        return conditions(source, scope_definition);
			case 'condition':
        return condition(source, scope_definition);
			case 'array':
        return create_array(source, scope_definition);
			case 'lambda':
        return create_lambda(source, scope_definition);
    }

    throw new Exception("Invalid block: " + source.type);
  }

	public function convert_statement(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature = null):Expression {

    switch(source.type) {
      case 'block':
        return create_block(source, scope_definition);
      case 'symbol':
        return create_symbol(source, scope_definition);
      //case 'set_property':
        //return set_property(source, scope_definition);
			case 'new_scope':
				return new_scope(source, scope_definition);
			case 'create_node':
        return create_node(source, scope_definition);
			case 'if':
        return if_statement(source, scope_definition);
      case 'constraint':
        return constraint(source, scope_definition);
			case 'weight':
        return weight(source, scope_definition);
		}

    throw new Exception("Invalid block: " + source.type);
  }

  function constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
		//var reference = Reference.from_scope(source.path, scope_definition);
		var reference = convert_expression(source.reference, scope_definition);
		var back_reference:Expression = null;
		var operator_name = source.operator;
		if (['+=', '-=', '*=', '/='].indexOf(operator_name) > -1) {
			//operator_name = operator_name.substring(0, operator_name.length - 7);
			back_reference = reference;
		}
		//var operator = Type.createEnum(Functions, operator_name);
		var expression = convert_expression(source.expression, scope_definition);
		//var expression = function_expression(source.expression, scope_definition, name, back_reference);
		return new metahub.code.expressions.Create_Constraint(reference, expression, operator_name, back_reference != null);
  }

  function create_block(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var count = Reflect.fields(source.expressions).length;
    if (count == 0)
			return new metahub.code.expressions.Block();

		var fields = Reflect.fields(source.expressions);

		if (count == 1) {
			var expression = Reflect.field(source.expressions, fields[0]);
      return convert_statement(expression, scope_definition);
		}
    var block = new metahub.code.expressions.Block();

    for (e in fields) {
      var child = Reflect.field(source.expressions, e);
      block.add(convert_statement(child, scope_definition));
    }

    return block;
  }

  function create_literal(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var type = get_type(source.value);
    return new metahub.code.expressions.Literal(source.value, type);
  }

  function function_expression(source:Dynamic, scope_definition:Scope_Definition, name:String, reference:Expression = null):Expression {
    var expressions:Array<Dynamic> = source.inputs;
    var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope_definition)));

			// Equavelent to += in other languages
		if (reference != null) {
			//name = name.substring(0, 1);
			inputs.unshift(reference);
		}

		//var func = Type.createEnum(Functions, name);
    //var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope_definition, type)));
		var info = Function_Call.get_function_info(name, hub);
    return new metahub.code.expressions.Function_Call(name, info, inputs, hub);
  }

  function if_statement(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var condition = convert_expression(source.condition, scope_definition);
		var expression = convert_expression(source.action, scope_definition);
		return new If_Statement(condition, expression);
  }

  function conditions(source:Conditions_Source, scope_definition:Scope_Definition):Expression {
		var expressions = new Array<Expression>();
		for (i in source.conditions) {
			expressions.push(convert_expression(i, scope_definition));
		}
		return new Condition_Group(expressions,
			expressions.length > 1 ? Condition_Join.createByName(source.mode) : Condition_Join.and
		);
  }

  function condition(source:Dynamic, scope_definition:Scope_Definition):Expression {
		return new Condition(
			convert_expression(source.first, scope_definition),
			convert_expression(source.second, scope_definition),
			Functions.createByName(source.operator));
  }

  function create_node(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var path:Array<String> = source.trellis;
		if (path.length == 0)
			throw new Exception("Trellis path is empty for node creation.");

		var namespace = hub.schema.root_namespace.get_namespace(path);
    var trellis = hub.schema.get_trellis(path[path.length - 1], namespace, true);
		var new_scope = new Scope_Definition(scope_definition);
		new_scope.is_particular_node = true;
		new_scope.trellis = trellis;

		var block = source.block != null
			? create_block(source.block, new_scope)
			: null;

		return new metahub.code.expressions.Create_Node(trellis, new_scope, block);
  }

	function extract_path(path:Dynamic):Array<String> {
		var result = new Array<String>();
		for (i in 1...path.length) {
			result.push(path[i]);
		}

		return result;
	}

  function create_path(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var trellis:Trellis = scope_definition.trellis;
		var expression:Expression = null;
		var children = new Array<Expression>();
		var expressions:Array<Dynamic> = source.children;
		if (expressions.length == 0)
			throw new Exception("Empty reference path.");

		if (expressions[0].type == "reference" && trellis.get_property_or_null(expressions[0].name) == null) {
				return function_path(source, scope_definition);
		}

		for (item in expressions) {
			if (item.type == "function") {
				var info = Function_Call.get_function_info(item.name, hub);
				children.push(new metahub.code.expressions.Function_Call(item.name, info, [], hub));
			}
			else if (item.type == "reference") {
				var property = trellis.get_property_or_error(item.name);
				children.push(new Property_Reference(property, trellis));
				if (property.other_trellis != null)
					trellis = property.other_trellis;
			}
			else {
				throw new Exception("Invalid path token type: " + item.type);
			}
		}
		return new Path_Expression(children);
  }

	function function_path(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var path = new Array<String>();
		var expressions:Array<Dynamic> = source.children;
		for (expression in expressions) {
			path.push(expression.name);
		}

		var fullname = path.join(".");
		var namespace = hub.metahub_namespace.get_namespace(path);
		if (namespace == null)
			throw new Exception("Could not find " +	fullname);

		var name = path[path.length - 1];
		if (!namespace.function_library.exists(name))
			throw new Exception("Could not find function " +	fullname);

			var info = {
				library: namespace.function_library,
				index: namespace.function_library.get_function_id(name)
			};
		return new Function_Call(fullname, info, [], hub);
	}
  //function create_general_reference(source:Dynamic, scope_definition:Scope_Definition, trellis:Trellis):Expression_Reference {
		//return new Property_Reference();
  //}

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert_expression(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.get_type()[0]);
    return new metahub.code.expressions.Create_Symbol(symbol, expression);
  }

  static function get_type(value:Dynamic):Type_Signature {
    if (Std.is(value, Int)) {
			var result = new Type_Signature(Kind.unknown);
			result.is_numeric = 1;
      return result;
		}

    if (Std.is(value, Float))
      return new Type_Signature(Kind.float);

    if (Std.is(value, Bool))
      return new Type_Signature(Kind.bool);

    if (Std.is(value, String))
      return new Type_Signature(Kind.string);

    throw new Exception("Could not find type.");
  }

	function new_scope(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var path:Array<String> = source.path;
		if (path.length == 0)
			throw new Exception("Scope path is empty for node creation.");

		var expression:Expression = null;
		var new_scope_definition = new Scope_Definition(scope_definition);
		if (path.length == 1 && path[0] == 'new') {
			new_scope_definition.only_new = true;
			expression = convert_statement(source.expression, new_scope_definition);
			return new Scope_Expression(expression, new_scope_definition);
		}

		var namespace = hub.schema.root_namespace.get_namespace(path);
		var trellis = hub.schema.get_trellis(path[path.length - 1], namespace);

		if (trellis != null) {
			new_scope_definition.trellis = trellis;
			expression = convert_statement(source.expression, new_scope_definition);
			return new Scope_Expression(expression, new_scope_definition);
		}
		else {
			var symbol = scope_definition.find(source.path);
			new_scope_definition.symbol = symbol;
			new_scope_definition.trellis = symbol.get_trellis();
			expression = convert_statement(source.expression, new_scope_definition);
			return new Node_Scope(expression, new_scope_definition);
		}
	}

	function weight(source:Dynamic, scope_definition:Scope_Definition):Expression {
		return new Set_Weight(source.weight, convert_statement(source.statement, scope_definition));
  }
	
  function create_array(source:Dynamic, scope_definition:Scope_Definition):Expression {
		return create_block(source, scope_definition);
  }
	
  function create_lambda(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var new_scope = new Scope_Definition(scope_definition);
		var parameters:Array<String> = source.parameters;
		for (parameter in parameters) {			
			new_scope.add_symbol(parameter, new Type_Signature(Kind.unknown));
		}		
    
		return create_block(source, new_scope);
  }

}