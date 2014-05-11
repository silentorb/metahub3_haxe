package code;
import schema.Trellis;
import engine.Node;
import engine.IPort;

class Symbol_Reference {
  public var symbol:Symbol;
  public var property_path:Array<Int>;

  public function new(symbol:Symbol) {
    this.symbol = symbol;
  }

  public static function convert_string_path(path:Array<String>, trellis:Trellis, start_index:Int = 0):Array<Int> {
    var result = new Array<Int>();
    var x = start_index;
    while (x < path.length) {
      var property = trellis.get_property(path[x]);
      result.push(property.id);
      trellis = property.other_trellis;
      ++x;
    }

    return result;
  }

  public static function create(path:Array<String>, scope_definition:Scope_Definition):Symbol_Reference {
    var symbol = scope_definition.find(path[0]);
    var reference = new Symbol_Reference(symbol);
    if (path.length > 1) {
      var trellis = symbol.type.trellis;
      reference.property_path = convert_string_path(path, trellis, 1);
    }
    else {
      reference.property_path = new Array<Int>();
    }

    return reference;
  }

  public function get_port(scope:Scope):IPort {
    var node = get_node(scope);
    return node.get_port(property_path[property_path.length - 1]);
  }

  public function get_node(scope:Scope):Node {
    var node = symbol.get_node(scope);
    var nodes = scope.hub.nodes;
    var i = 0;
    var length = property_path.length - 1;
    while (i < length) {
      var id = node.get_value(property_path[i]);
      node = nodes[id];
      ++i;
    }

    return node;
  }

  public function resolve(scope:Scope):Dynamic {
    var node = get_node(scope);
    if (property_path.length > 0)
      return node.get_value(property_path[property_path.length - 1]);

    return node.id;
  }
}