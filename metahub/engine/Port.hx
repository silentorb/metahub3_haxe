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
	public var on_change = new Array<Port->Dynamic->Context->Void>();

//  public var action(get, set):Functions;
//	public function get_action():Functions {
//		return _action;
//	}
//	public function set_action(value):Functions {
//		return _action = value;
//	}

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

	//public var value(get, set):Dynamic;
  public function get_value():Dynamic {
    return _value;
  }

  public function set_value(new_value:Dynamic, context:Context = null):Dynamic {
    if (_value == new_value)
      return _value;

    _value = new_value;
    if (this.dependents != null && this.dependents.length > 0) {
      update_dependents(context);
    }

		if (property.ports != null && property.ports.length > 0) {
			update_property_dependents();
		}

    //if (action != Functions.none) {
			//var output:Port = cast parent.get_port(0);
			////parent.get_port(1)
			//var args = get_input_values(parent);
      //Function_Calls.call(action, args, Types.unknown);
		//}

		if (on_change != null && on_change.length > 0) {
			for (action in on_change) {
				action(this, _value, context);
			}
		}

		return _value;
  }

	public function get_type():Types {
		return property.type;
	}

  function update_dependents(context:Context) {
    for (other in dependents) {
      other.set_value(_value, context);
    }
  }

	function update_property_dependents() {
		trace('update_property_dependents');
		var context = new Context(null);
    for (port in property.ports) {
		trace('a');
      //var other:Port = cast node.get_port_from_chain(i);
      //var other:Port = cast i;
      port.enter(_value, context);
    }
  }
}
