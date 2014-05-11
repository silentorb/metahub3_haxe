package code;

import engine.Node;

class Symbol {
  public var type:Type_Reference;
  public var scope_definition:Scope_Definition;
  public var index:Int;
  public var name:String;

  public function new(type:Type_Reference, scope_definition:Scope_Definition, index:Int, name:String) {
    this.type = type;
    this.scope_definition = scope_definition;
    this.index = index;
    this.name = name;
  }

  public function get_node(scope:Scope):Node {
    var id = resolve(scope);
    return scope.hub.nodes[id];
  }

  public function resolve(scope:Scope):Dynamic {
    if (scope_definition.depth == scope.definition.depth)
      return scope.values[index];

    if (scope.parent == null)
      throw new Exception("Could not find scope for symbol: " + name + ".");

    return resolve(scope.parent);
  }

}
