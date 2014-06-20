package metahub.engine;

import metahub.engine.Node;
import metahub.schema.Property;

class Reference {

  public var node:Node;
  public var property:Property;

  public function new(node:Node, property:Property = null) {
    this.node = node;
    this.property = property;
  }
}


