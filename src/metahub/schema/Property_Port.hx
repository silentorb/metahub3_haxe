package metahub.schema;
import metahub.engine.Constraint_Operator;
import metahub.engine.Context;
import metahub.engine.IPort;
import metahub.engine.Node;
using metahub.schema.Property_Chain;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Property_Port implements IPort {
	var property:Property;
	var origin:Property_Chain;

	public var connections = new Array<IPort>();
  //public var dependents = new Array<Relationship>();

	public function new(property:Property, origin:Property_Chain) {
		this.property = property;
    this.origin = origin;
	}

  public function connect(other:IPort) {
    this.connections.push(other);
    other.connections.push(this);
  }

	public function get_type():Kind {
		return property.type;
	}

	public function get_value(context:Context = null):Dynamic {
		return context.entry_node.get_value(property.id);
	}

	public function set_value(value:Dynamic, context:Context = null):Dynamic {
		//update_dependents(value);
		exit(value, context);
		return value;
	}

	public function enter(value:Dynamic, context:Context = null) {
		return update_connections(value, context);
	}

	public function exit(value:Dynamic, context:Context = null) {
		if (context.property_port == null)
			throw new Exception("Not implemented.");
		var entry_node:Node = cast context.entry_node;
		context.property_port.origin.perform(entry_node, function(node:Node) {
			node.set_value(property.id, value);
		});

		//if (context.property_port.property.type == Kind.list) {
			//
		//}
		//else {
			//throw new Exception("Not implemented.");
		//}
	}

	public function update_connections(value:Dynamic, context:Context) {
		//throw new Exception("Property_Port.update_dependents is not implemented.");
    for (other in connections) {
      value = other.set_value(value, context);
    }

		return value;
  }
}