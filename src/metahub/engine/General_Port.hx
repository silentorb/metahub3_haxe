package metahub.engine;

import metahub.schema.Kind;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.functions.Functions;
import metahub.engine.Relationship;

/**
 * ...
 * @author Christopher W. Johnson
 */

class General_Port {
	public var connections = new Array<General_Port>();
	public var node:INode;
	public var id:Int;

	public function new(node:INode, id:Int) {
		this.node = node;
		this.id = id;
	}

	public function connect(port:General_Port) {
		if (connections.indexOf(port) > -1)
			return;

		connections.push(port);
		port.connections.push(this);
	}

  public function get_node_value(context:Context):Dynamic {
		return node.get_value(id, context);
	}

	public function set_node_value(value:Dynamic, context:Context, source:General_Port) {
		node.set_value(id, value, context, source);
	}

	public function get_external_value(context:Context):Dynamic {
		if (connections.length > 1) {
			var result = new Array<Dynamic>();
			for (connection in connections) {
				result.push(connection.get_node_value(context));
			}

			return result;
		}

		if (connections.length == 0)
			throw new Exception("Cannot get_external_value from an unconnected port.");

		return connections[0].get_node_value(context);
	}

	public function set_external_value(value:Dynamic, context:Context) {
		for (connection in connections) {
			connection.set_node_value(value, context, this);
		}
	}
}
/*
class Port2 implements IPort {
  var _value:Dynamic;
  public var property:Property;
  public var parent:Node;
  public var connections = new Array<IPort>();
	var hub:Hub;
	//var _action:Functions = Functions.none;
	public var on_change = new Array<Port->Dynamic->Context->Void>();

  public function new(node:Node, hub:Hub, property:Property, value:Dynamic = null) {
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

	public function get_other_node():INode {
		var node_id:Int = cast _value;
		return hub.get_node(node_id);
	}

  public function get_value(context:Context):Dynamic {
    return _value;
  }

  public function set_value(new_value:Dynamic, context:Context):Dynamic {
    if (!property.multiple && _value == new_value) {
			hub.history.log("attempted " + property.fullname() + "|set_value " + new_value);
			return _value;
		}

		for (connection in connections) {
			new_value = connection.set_value(new_value, context);
		}

		var old_value = _value;
    _value = new_value;
		hub.history.log(property.fullname() + "|set_value " + new_value);

		new_value = update_property_connections(new_value, context);

		// Check again if the value is the same now that the value may have been modified by relationships.
		if (!property.multiple && old_value == new_value) {
			_value = new_value;
      return _value;
		}

    if (property.type == Kind.reference) {
      if (property.other_property.type == Kind.list) {
        var other_node = get_other_node();
        var other_port:List_Port = cast other_node.get_port(property.other_property.id);
				other_port.add_value(parent.id);
      }
      else {

      }
    }

    //if (this.connections != null && this.connections.length > 0) {
      //update_connections(context);
    //}

		if (property.port != null) {
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
		//throw new Exception("Base_Port.update_connections is not implemented.");

    for (other in connections) {
      other.set_value(_value, context);
    }
  }

	function update_property_connections(new_value:Dynamic, context:Context):Dynamic {
		if (property.port == null)
			return new_value;

		var context = new Context(parent, hub);
		new_value = property.port.output(new_value, context);

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
}*/