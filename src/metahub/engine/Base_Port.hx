package metahub.engine;

import metahub.schema.Kind;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.Functions;
import metahub.schema.Types;
using metahub.schema.Property_Chain;
import metahub.engine.Relationship;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Base_Port<T> implements IPort {
  var _value:T;
  public var property:Property;
  public var parent:INode;
  public var connections = new Array<IPort>();
	var hub:Hub;
	//var _action:Functions = Functions.none;
	public var on_change = new Array<Base_Port<T>->T->Context->Void>();

  public function new(node:INode, hub:Hub, property:Property, value:Dynamic = null) {
    this.parent = node;
		this.hub = hub;
    this.property = property;
    this._value = value;
  }

  public function connect(other:IPort) {
    this.connections.push(other);
    other.connections.push(this);
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
    if (!property.multiple && _value == new_value)
      return _value;

		//for (connection in connections) {
			//new_value = connection.set_value(new_value, context);
		//}

		new_value = update_property_connections(new_value, context);

		// Check again if the value is the same now that the value may have been modified by relationships.
		if (!property.multiple && _value == new_value)
      return _value;

    _value = new_value;

    if (property.type == Kind.reference) {
      if (property.other_property.type == Kind.list) {
        var other_node = get_other_node();
        var other_port:List_Port = cast other_node.get_port(property.other_property.id);
				other_port.add_value(parent.id);
      }
      else {

      }
    }

    if (this.connections != null && this.connections.length > 0) {
      update_connections(context);
    }

		if (property.ports != null && property.ports.length > 0) {
			update_property_connections(new_value, null);
		}

		if (on_change != null && on_change.length > 0) {
			for (action in on_change) {
				action(this, _value, context);
			}
		}

		return _value;
  }

	public function get_type():Kind {
		return property.type;
	}

  function update_connections(context:Context) {
		throw new Exception("Base_Port.update_connections is not implemented.");

    //for (other in connections) {
      //other.set_value(_value, context);
    //}
  }

	function update_property_connections(new_value:Dynamic, context:Context):Dynamic {
    for (port in property.ports) {
  		var context = new Context(port, parent);
    //var other:Port = cast node.get_port_from_chain(i);
      //var other:Port = cast i;
      new_value = port.enter(new_value, context);
    }

		return new_value;
  }

	//function check_property_dependencies(new_value:Dynamic, context:Context) {
    //for (port in property.ports) {
  		//var context = new Context(port, parent);
			//for (relationship in port.dependencies) {
				//new_value = relationship.check_value(new_value, context);
			//}
		//}
//
		//return new_value;
  //}
}