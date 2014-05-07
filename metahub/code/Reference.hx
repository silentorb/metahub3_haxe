package code;
import schema.Property;
import Node;

interface IReference {

}

class Node_Reference implements IReference {
  var node:INode;

  public function new(node:Node) {
    this.node = node;
  }
}

class Property_Reference implements IReference {

  var node:INode;
  var property:Property;

  public function new(node:INode, property:Property) {
    this.node = node;
    this.property = property;
  }
}