package code;

class Scope {
  public var hub:Hub;
  public var definition:Scope_Definition;
  var values = new Array<Dynamic>();
  var parent:Scope;

  public function new(hub:Hub, definition:Scope_Definition, parent:Scope = null) {
    this.hub = hub;
    this.definition = definition;
    this.parent = parent;
  }

  public function resolve_symbol(symbol:Symbol):Dynamic {
    if (symbol.scope_definition.depth == definition.depth)
      return values[symbol.index];

    if (parent == null)
      throw "Could not find scope for symbol: " + symbol.name + ".";

    return parent.resolve_symbol(symbol);
  }
}