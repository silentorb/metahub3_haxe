package engine;

import schema.Trellis;
import schema.Property;
import code.Functions;

class List_Port implements IPort {
  var values = new Array<Dynamic>();
  public var property:Property;
  public var node:Node;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
  public var action:Functions = Functions.none;

  public function new(node:Node, property:Property) {
    this.node = node;
    this.property = property;
  }

  public function get_value(index:Int):Dynamic {
    return values[index];
  }

  public function set_value(new_value:Dynamic, index:Int) {
    values[index] = new_value;
  }

  public function add_value(new_value:Dynamic) {
    values.push(new_value);
  }

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }

}