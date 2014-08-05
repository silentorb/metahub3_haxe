package metahub.code;
import metahub.code.expressions.Trellis_Scope;
import metahub.code.references.Reference;
import metahub.engine.Constraint_Operator;
import metahub.Hub;
import metahub.schema.Kind;
import metahub.schema.Namespace;
import metahub.schema.Property;
import metahub.code.expressions.*;
import metahub.schema.Types;
import metahub.code.references.*;
import metahub.code.symbols.*;
import metahub.code.functions.Functions;
import metahub.code.statements.*;

class Coder {
  var hub:Hub;

  public function new(hub:Hub) {
    this.hub = hub;
  }

  public function convert_expression(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature = null):Expression {

    switch(source.type) {
      case 'literal':
        return create_literal(source, scope_definition);
      case 'reference':
        return create_reference(source, scope_definition);
      case 'function':
        return function_expression(source, scope_definition, type);
			case 'node':
        return create_node(source, scope_definition);
    }

    throw new Exception("Invalid block: " + source.type);
  }

	public function convert_statement(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature = null):Statement {

    switch(source.type) {
      case 'block':
        return create_block(source, scope_definition);
      case 'constraint':
        return constraint(source, scope_definition);
      case 'symbol':
        return create_symbol(source, scope_definition);
      case 'set':
        return set(source, scope_definition);
			case 'trellis_scope':
				return trellis_scope(source, scope_definition);
    }

    throw new Exception("Invalid block: " + source.type);
  }

  function constraint(source:Dynamic, scope_definition:Scope_Definition):Statement {
		//var operator:Constraint_Operator = cast Constraint.operators.indexOf(source.operator);
    //var reference = scope_definition.find(source.path);
		if (scope_definition._this.get_layer() == Layer.schema) {
			var reference:Reference<ISchema_Symbol> = path_to_schema_reference(source.path, scope_definition);
			var expression = convert_expression(source.expression, scope_definition, reference.get_type_reference());
			return new metahub.code.statements.Create_Constraint(reference, expression);
		}
		else {
			throw new Exception("Not currently maintained.");
			//var reference:Reference<Local_Symbol> = path_to_engine_reference(source.path, scope_definition);
			//return new metahub.code.expressions.Create_Constraint(reference, operator, expression);
		}
  }

  function create_block(source:Dynamic, scope_definition:Scope_Definition):Statement {
    var new_scope_definition = new Scope_Definition(scope_definition);
    var block = new metahub.code.statements.Block(new_scope_definition);

    for (e in Reflect.fields(source.expressions)) {
      var child = Reflect.field(source.expressions, e);
      block.statements.push(convert_statement(child, new_scope_definition));
    }

    return block;
  }

  function create_literal(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var type = get_type(source.value);
    return new metahub.code.expressions.Literal(source.value, new Type_Signature(type));
  }

	function get_namespace(path:Array<String>, start:Namespace):Namespace {
		var current_namespace = start;
		var i = 0;
		for (token in path) {
			if (current_namespace.children.exists(token)) {
				current_namespace = current_namespace.children[token];
			}
			else if (current_namespace.trellises.exists(token) && i == path.length - 1) {
				return current_namespace;
			}
			else {
				return null;
			}
			++i;
		}

		return current_namespace;
	}

  function create_node(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var path:Array<String> = source.trellis;
		if (path.length == 0)
			throw new Exception("Trellis path is empty for node creation.");

		var namespace = get_namespace(path, hub.schema.root_namespace);
    var trellis = hub.schema.get_trellis(path[path.length - 1], namespace, true);
    var result = new metahub.code.expressions.Create_Node(trellis);

    if (source.set != null) {
      for (key in Reflect.fields(source.set)) {
        var property = trellis.get_property(key);
        result.assignments[property.id] = convert_expression(Reflect.field(source.set, key), scope_definition);
      }
    }
    return result;
  }

	function path_to_engine_reference(path, scope_definition:Scope_Definition):Reference<Local_Symbol> {
		var symbol:Local_Symbol = cast scope_definition.find(path[0], hub.schema.root_namespace);
		return symbol.create_reference(extract_path(path));
	}

	function extract_path(path:Dynamic):Array<String> {
		var result = new Array<String>();
		for (i in 1...path.length) {
			result.push(path[i]);
		}

		return result;
	}

	function path_to_schema_reference(path, scope_definition:Scope_Definition):Reference<ISchema_Symbol> {
		var symbol:ISchema_Symbol = cast scope_definition.find(path[0], hub.schema.root_namespace);
		return symbol.create_reference(extract_path(path));
	}

	//function create_expression_with_reference(path, scope_definition:Scope_Definition, func:Reference<T>-> Expression):Expression {
		//var reference = scope_definition._this != null && scope_definition._this.get_layer() == Layer.schema
		//? path_to_schema_reference(path, scope_definition)
		//: path_to_engine_reference(path, scope_definition);
//
		//return func(reference);
  //}

  function create_reference(source:Dynamic, scope_definition:Scope_Definition):Expression {
		//return create_expression_with_reference(source.path, scope_definition, function(r) new Expression_Reference(r));
		if (scope_definition._this != null && scope_definition._this.get_layer() == Layer.schema) {
			var reference = path_to_schema_reference(source.path, scope_definition);
	    return new Expression_Reference(reference);
		}
		else {
			var reference = path_to_engine_reference(source.path, scope_definition);
	    return new Expression_Reference(reference);
		}
  }

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Statement {
    var expression = convert_expression(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.get_types()[0][0]);
    return new metahub.code.statements.Create_Symbol(symbol, expression);
  }

  static function get_type(value:Dynamic):Kind {
    if (Std.is(value, Int))
      return Kind.int;

    if (Std.is(value, Float))
      return Kind.float;

    if (Std.is(value, Bool))
      return Kind.bool;

    if (Std.is(value, String))
      return Kind.string;

    throw new Exception("Could not find type.");
  }

  function function_expression(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature):Expression {
		if (type == null)
			throw new Exception("Function expressions do not currently support unspecified return types.");

		var func = Type.createEnum(Functions, source.name);
    var expressions:Array<Dynamic> = source.inputs;
    var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope_definition, type)));
    return new metahub.code.expressions.Function_Call(func, type, inputs, hub);
  }

  function set(source:Dynamic, scope_definition:Scope_Definition):Statement {
    var reference:Local_Symbol = cast scope_definition.find(source.path, hub.schema.root_namespace);
    var trellis = reference.get_trellis();
    //var trellis = reference.symbol.type.trellis;

    var result = new metahub.code.statements.Set(reference);
    for (e in Reflect.fields(source.assignments)) {
      var assignment = Reflect.field(source.assignments, e);
      var property = trellis.get_property(e);
      result.add_assignment(property.id, convert_expression(assignment, scope_definition));
    }
    return result;
  }

	function trellis_scope(source:Dynamic, scope_definition:Scope_Definition):Statement {
		var path:Array<String> = source.path;
		if (path.length == 0)
			throw new Exception("Trellis path is empty for node creation.");

		var namespace = get_namespace(path, hub.schema.root_namespace);

    var new_scope_definition = new Scope_Definition(scope_definition);
		var trellis = hub.schema.get_trellis(path[path.length - 1], namespace);
		new_scope_definition._this = new Trellis_Symbol(trellis);
		var statements = new Array<Statement>();
		for (i in Reflect.fields(source.statements)) {
      var statement = Reflect.field(source.statements, i);
			statements.push(convert_statement(statement, new_scope_definition));
		}
		return new Trellis_Scope(trellis, statements, new_scope_definition);
  }
}