package engine;

import schema.Trellis;
import schema.Property;
import code.Functions;
import schema.Types;

class Port implements IPort {
  var _value:Dynamic;
  public var property:Property;
  public var parent:INode;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
	var hub:Hub;
	var _action:Functions = Functions.none;
  public var action(get, set):Functions;
	public function get_action():Functions {
		return _action;
	}
	public function set_action(value):Functions {
		return _action = value;
	}

  public function new(node:INode, hub:Hub, property:Property, value:Dynamic = null) {
    this.parent = node;
		this.hub = hub;
    this.property = property;
    this._value = value;
  }

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }

  public function get_index():Int {
    return property.id;
  }

	public function get_other_node():Node {
		var node_id:Int = cast _value;
		return hub.nodes[node_id];
	}

	public var value(get, set):Dynamic;
  public function get_value():Dynamic {
    return _value;
  }

  public function set_value(new_value:Dynamic):Dynamic {
    if (_value == new_value)
      return _value;

    _value = new_value;
    if (this.dependents != null && this.dependents.length > 0) {
      update_dependents();
    }

		if (property.dependents != null && this.dependents.length > 0) {
			update_property_dependents();
		}

    if (action != Functions.none) {
			var output:Port = cast parent.get_port(0);
			//parent.get_port(1)
			var args = get_input_values(parent);
      Function_Calls.call(action, args, Types.unknown);
		}

		return _value;
  }

	public static function get_input_values(node:INode):Iterable<Dynamic> {
		var result = new Array<Dynamic>();
		for (i in 1...2) {
			var value = node.get_port(i).get_value();
			result.push(value);
		}
		return result;
	}

  function update_dependents() {
    for (i in dependents) {
      var other:Port = cast i;
      other.set_value(_value);
    }
  }

	function update_property_dependents() {
    for (i in property.dependents) {
      //var other:Port = cast node.get_port_from_chain(i);
      var other:Port = cast i;
      other.set_value(_value);
    }
  }
}
