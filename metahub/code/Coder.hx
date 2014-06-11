package code;
import code.expressions.Trellis_Scope;
import code.references.Reference;
import Hub;
import schema.Property;
import code.expressions.*;
import schema.Types;
import code.references.*;
import code.symbols.*;

class Coder {
  var hub:Hub;

  public function new(hub:Hub) {
    this.hub = hub;
  }

  public function convert(source:Dynamic, scope_definition:Scope_Definition):Expression {

    switch(source.type) {
      case 'block':
        return create_block(source, scope_definition);
      case 'constraint':
        return constraint(source, scope_definition);
      case 'node':
        return create_node(source, scope_definition);
      case 'symbol':
        return create_symbol(source, scope_definition);
      case 'literal':
        return create_literal(source, scope_definition);
      case 'reference':
        return create_reference(source, scope_definition);
      case 'function':
        return function_expression(source, scope_definition);
      case 'set':
        return set(source, scope_definition);
			case 'trellis_scope':
				return trellis_scope(source, scope_definition);
    }

    throw new Exception("Invalid block: " + source.type);
  }

  function constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert(source.expression, scope_definition);
    //var reference = scope_definition.find(source.path);
		if (scope_definition._this.get_layer() == Layer.schema) {
			var reference:Reference<ISchema_Symbol> = path_to_schema_reference(source.path, scope_definition);
			return new code.expressions.Create_Constraint(reference, expression);
		}
		else {
			var reference:Reference<Local_Symbol> = path_to_engine_reference(source.path, scope_definition);
			return new code.expressions.Create_Constraint(reference, expression);
		}
  }

  //function create_constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
    //var expression = convert(source.expression, scope_definition);
    //var reference = scope_definition.find(source.path);
    //return new code.expressions.Create_Constraint(reference, expression);
  //}

  function create_block(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var new_scope_definition = new Scope_Definition(scope_definition);
    var block = new code.expressions.Block(new_scope_definition);

    for (e in Reflect.fields(source.expressions)) {
      var child = Reflect.field(source.expressions, e);
      block.expressions.push(convert(child, new_scope_definition));
    }

    return block;
  }

  function create_literal(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var type = get_type(source.value);
    return new code.expressions.Literal(source.value, new Type_Reference(type));
  }

  function create_node(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var trellis = hub.schema.get_trellis(source.trellis);
    var result = new code.expressions.Create_Node(trellis);

    if (source.set != null) {
      for (key in Reflect.fields(source.set)) {
        var property = trellis.get_property(key);
        result.assignments[property.id] = convert(Reflect.field(source.set, key), scope_definition);
      }
    }
    return result;
  }

	function path_to_engine_reference(path, scope_definition:Scope_Definition):Reference<Local_Symbol> {
		var symbol:Local_Symbol = cast scope_definition.find(path[0]);
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
		var symbol:ISchema_Symbol = cast scope_definition.find(path[0]);
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

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.type);
    return new code.expressions.Create_Symbol(symbol, expression);
  }

  static function get_type(value:Dynamic):Types {
    if (Std.is(value, Int))
      return Types.int;

    if (Std.is(value, Float))
      return Types.float;

    if (Std.is(value, Bool))
      return Types.bool;

    if (Std.is(value, String))
      return Types.string;

    throw new Exception("Could not find type.");
  }

  function function_expression(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var trellis = this.hub.schema.get_trellis(source.name);
    var expressions:Array<Dynamic> = source.inputs;
    var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert(e, scope_definition)));
    return new code.expressions.Function_Call(trellis, inputs);
  }

  function set(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var reference:Local_Symbol = cast scope_definition.find(source.path);
    var trellis = reference.get_trellis();
    //var trellis = reference.symbol.type.trellis;

    var result = new code.expressions.Set(reference);
    for (e in Reflect.fields(source.assignments)) {
      var assignment = Reflect.field(source.assignments, e);
      var property = trellis.get_property(e);
      result.add_assignment(property.id, convert(assignment, scope_definition));
    }
    return result;
  }

	function trellis_scope(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var new_scope_definition = new Scope_Definition(scope_definition);
		var trellis = hub.schema.get_trellis(source.path);
		new_scope_definition._this = new Trellis_Symbol(trellis);
		var statements = new Array<Expression>();
		for (i in Reflect.fields(source.statements)) {
      var statement = Reflect.field(source.statements, i);
			statements.push(convert(statement, new_scope_definition));
		}
		return new Trellis_Scope(trellis, statements, new_scope_definition);
  }
}