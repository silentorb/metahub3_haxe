package code;
import Hub;
import schema.Property;

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
    }

    throw "Invalid block: " + source.type;
  }

  function create_constraint(source:Dynamic, scope_definition:Scope_Definition):Expression {
    return null;
  }

  function create_block(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var new_scope_definition = new Scope_Definition(scope_definition);
    var block = new Expression_Block(new_scope_definition);

    for (e in Reflect.fields(source.expressions)) {
      var child = Reflect.field(source.expressions, e);
      block.expressions.push(convert(child, new_scope_definition));
    }

    return block;
  }

  function create_literal(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var type = get_type(source.value);
    return new Expression_Literal(source.value, new Type_Reference(type));
  }

  function create_node(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var trellis = hub.schema.get_trellis(source.trellis);
    var result = new Expression_Create_Node(trellis);

    if (source.set != null) {
      for (key in Reflect.fields(source.set)) {
        var property = trellis.get_property(key);
        result.assignments[property.id] = convert(Reflect.field(source.set, key), scope_definition);
      }
    }
    return result;
  }

  function create_reference(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var symbol = scope_definition.find(source.path);
    return new Expression_Reference(symbol);
  }

  function create_symbol(source:Dynamic, scope_definition:Scope_Definition):Expression {
    var expression = convert(source.expression, scope_definition);
    var symbol = scope_definition.add_symbol(source.name, expression.type);
    return new Expression_Create_Symbol(symbol, expression);
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

    throw "Could not find type.";
  }
}