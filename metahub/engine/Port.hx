package engine;

import schema.Trellis;
import schema.Property;
import code.Functions;

class Port implements IPort {
  var value:Dynamic;
  public var property:Property;
  public var node:Node;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
  public var action:Functions = Functions.none;

  public function new(node:Node, property:Property, value:Dynamic = null) {
    this.node = node;
    this.property = property;
    this.value = value;
  }

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }

  public function get_index():Int {
    return property.id;
  }

  public function get_value():Dynamic {
    return value;
  }

  public function set_value(new_value:Dynamic) {
    if (value == new_value)
      return;

    value = new_value;
    if (this.dependents != null && this.dependents.length > 0) {
      update_dependents();
    }

    if (action != Functions.none)
      Function_Calls.call(action, this.node);
  }

  function update_dependents() {
    for (i in dependents) {
      var other:Port = cast i;
      other.set_value(value);
    }
  }
}
