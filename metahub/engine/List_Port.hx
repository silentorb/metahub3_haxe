package engine;

import schema.Trellis;
import schema.Property;
import code.Functions;

class List_Port implements IPort {
  var values = new Array<Dynamic>();
  public var property:Property;
  public var parent:INode;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
  var _action:Functions = Functions.none;
  public var action(get, set):Functions;
	public function get_action():Functions {
		return _action;
	}
	public function set_action(value):Functions {
		return _action = value;
	}

  public function new(node:Node, property:Property) {
    this.parent = node;
    this.property = property;
  }

  public function get_value_at(index:Int):Dynamic {
    return values[index];
  }

	public function get_value():Dynamic {
    return values;
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