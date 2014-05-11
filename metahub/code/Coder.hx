package code;
import Hub;
import schema.Property;
import code.expressions.Expression;

class Coder {
  var hub:Hub;

  public function new(hub:Hub) {
    this.hub = hub;
  }

  public function convert(source:Dynamic, scope_definition:Scope_Definition):Expression {

    switch(source.type) {
      case 'block':
        return create_block(source, scope_definition);
      case 'create_constraint':
        return create_constraint(source, scope_definition);
      case 'create_node':
        return create_node(source, scope_definition);
      case 'create_symbol':
        return create_symbol(source, scope_definition);
      case 'literal':
        return create_literal(source, scope_definition);
      case 'reference':
        return create_reference(source, scope_definition);
      case 'function':
        return function_expression(source, scope_definition);
      case 'set':
        return set(source, scope_definition);
    }

    throw new Exception("Invalid block: " + source.type);
  }

  function create_constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert(source.expression, scope_definition);
    var reference = Symbol_Reference.create(source.path, scope_definition);
    return new code.expressions.Create_Constraint(reference, expression);
  }

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

  function create_reference(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var reference = Symbol_Reference.create(source.path, scope_definition);
    return new code.expressions.Expression_Reference(reference);
  }

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.type);
    return new code.expressions.Create_Symbol(symbol, expression);
  }

  static function get_type(value:Dynamic):Property_Type {
    if (Std.is(value, Int))
      return Property_Type.int;

    if (Std.is(value, Float))
      return Property_Type.float;

    if (Std.is(value, Bool))
      return Property_Type.bool;

    if (Std.is(value, String))
      return Property_Type.string;

    throw new Exception("Could not find type.");
  }

  function function_expression(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var trellis = this.hub.schema.get_trellis(source.name);
    var expressions:Array<Dynamic> = source.inputs;
    var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert(e, scope_definition)));
    return new code.expressions.Function_Call(trellis, inputs);
  }

  function set(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var reference = Symbol_Reference.create(source.path, scope_definition);
    var trellis =reference.symbol.type.trellis;

    var result = new code.expressions.Set(reference);
    for (e in Reflect.fields(source.assignments)) {
      var assignment = Reflect.field(source.assignments, e);
      var property =trellis.get_property(assignment.property);
      result.add_assignment(property.id, convert(assignment.expression, scope_definition));
    }
    return result;
  }

}