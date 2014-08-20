package metahub.code;
import metahub.code.expressions.Trellis_Scope;
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
	operator:String
}

class Coder {
  var hub:Hub;

  public function new(hub:Hub) {
    this.hub = hub;
  }

  public function convert_expression(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature = null):Expression {

    switch(source.type) {
			case 'block':
        return create_block(source, scope_definition);
      case 'literal':
        return create_literal(source, scope_definition);
      case 'reference':
        return create_general_reference(source, scope_definition);
      case 'function':
        return function_expression(source, scope_definition, type);
			case 'create_node':
        return create_node(source, scope_definition);
			case 'conditions':
        return conditions(source, scope_definition);
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
		}

    throw new Exception("Invalid block: " + source.type);
  }

  function constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var reference = Reference.from_scope(source.path, scope_definition);
		var back_reference:Reference = null;
		var name = source.expression.name;
		if (['+=', '-=', '*=', '/='].indexOf(name) > -1) {
			name = name.substring(0, 1);
			back_reference = reference;
		}
		var expression = function_expression(source.expression, scope_definition, reference.get_type(), back_reference);
		return new metahub.code.statements.Create_Constraint(reference, expression, back_reference != null);
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

  function function_expression(source:Dynamic, scope_definition:Scope_Definition, type:Type_Signature, reference:Reference = null):Expression {
		if (type == null)
			throw new Exception("Function expressions do not currently support unspecified return types.");

		var name = source.name;
    var expressions:Array<Dynamic> = source.inputs;
    var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope_definition, type)));

			// Equavelent to += in other languages
		if (reference != null && ['+=', '-=', '*=', '/='].indexOf(name) > -1) {
			name = name.substring(0, 1);
			inputs.unshift(new Expression_Reference(reference));
		}

		var func = Type.createEnum(Functions, name);
    //var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope_definition, type)));
    return new metahub.code.expressions.Function_Call(func, type, inputs, hub);
  }

  function if_statement(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var condition = convert_expression(source.condition, scope_definition);
		var expression = convert_expression(source.expression, scope_definition);
		return new If_Statement(condition, expression);
  }

  function conditions(source:Conditions_Source, scope_definition:Scope_Definition):Expression {
		var conditions = new Array<Expression>();
		for (i in source.conditions) {
			conditions.push(convert_expression(i, scope_definition));
		}
		return new Condition_Group(conditions, Condition_Join.createByName(source.operator));
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
		var new_scope = new Scope_Definition(scope_definition);
		new_scope.trellis = trellis;
    var result = new metahub.code.expressions.Create_Node(trellis, new_scope);

    if (source.set != null) {
			result.expression = create_block(source.set, new_scope);
      //for (key in Reflect.fields(source.set)) {
        //var property = trellis.get_property(key);
        //result.assignments[property.id] = convert_expression(Reflect.field(source.set, key), scope_definition);
      //}
    }
    return result;
  }

	function extract_path(path:Dynamic):Array<String> {
		var result = new Array<String>();
		for (i in 1...path.length) {
			result.push(path[i]);
		}

		return result;
	}

  function create_general_reference(source:Dynamic, scope_definition:Scope_Definition):Expression {
		return new Expression_Reference(Reference.from_scope(source.path, scope_definition));
  }

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert_expression(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.get_types()[0][0]);
    return new metahub.code.statements.Create_Symbol(symbol, expression);
  }

	function set_property(source:Dynamic, scope_definition:Scope_Definition):Expression {
		var reference = Reference.from_scope(source.path, scope_definition);
    var expression = convert_expression(source.expression, scope_definition);

		// Equavelent to += in other languages
		if (Reflect.hasField(source, "modifier") && source.modifier != Functions.none) {
			var func = Type.createEnum(Functions, source.modifier);
			var inputs = [ new Expression_Reference(reference), expression ];
			expression = new Function_Call(func, reference.get_type(), inputs, hub);
		}

		return new Assignment(reference, expression);
  }

  static function get_type(value:Dynamic):Type_Signature {
    if (Std.is(value, Int)) {
			var result = new Type_Signature(Kind.unknown);
			result.is_numeric = true;
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
		var namespace = get_namespace(path, hub.schema.root_namespace);
		var trellis = hub.schema.get_trellis(path[path.length - 1], namespace);

		if (trellis != null) {
			new_scope_definition.trellis = trellis;
			expression = convert_statement(source.expression, new_scope_definition);
			return new Trellis_Scope(trellis, expression, new_scope_definition);
		}
		else {
			var symbol = scope_definition.find(source.path);
			new_scope_definition.symbol = symbol;
			new_scope_definition.trellis = symbol.get_trellis();
			expression = convert_statement(source.expression, new_scope_definition);
			return new Node_Scope(expression, new_scope_definition);
		}
	}
}