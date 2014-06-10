package engine;

import engine.Node;
import schema.Property;

class Reference {

  public var node:Node;
  public var property:Property;

  public function new(node:Node, property:Property = null) {
    this.node = node;
    this.property = property;
  }
}


