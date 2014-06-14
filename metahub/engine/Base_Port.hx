package engine;

import schema.Trellis;
import schema.Property;
import code.Functions;
import schema.Types;
using schema.Property_Chain;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Base_Port<T> implements IPort {
  var _value:T;
  public var property:Property;
  public var parent:INode;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
	var hub:Hub;
	//var _action:Functions = Functions.none;
	public var on_change = new Array<Base_Port<T>->T->Context->Void>();

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
		return hub.get_node(node_id);
	}

  public function get_value(context:Context = null):Dynamic {
    return _value;
  }

  public function set_value(new_value:Dynamic, context:Context = null):Dynamic {
    if (_value == new_value)
      return _value;

    _value = new_value;

    if (property.type == Types.reference) {
      if (property.other_property.type == Types.list) {
        var other_node = get_other_node();
        var other_port:List_Port = cast other_node.get_port(property.other_property.id);
				other_port.add_value(parent.id);
      }
      else {

      }
    }

    if (this.dependents != null && this.dependents.length > 0) {
      update_dependents(context);
    }

		if (property.ports != null && property.ports.length > 0) {
			update_property_dependents();
		}

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
    for (port in property.ports) {
  		var context = new Context(port, parent);
    //var other:Port = cast node.get_port_from_chain(i);
      //var other:Port = cast i;
      port.enter(_value, context);
    }
  }
}