package metahub.schema;
import metahub.engine.Constraint_Operator;
import metahub.engine.Context;
import metahub.code.nodes.INode;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */

 /*
	*  The purpose of Property_Port is to keep the pipeline related functionality separate from
	*  Property, since there are cases where Property is simply used for schema definition.
	*
	*/

 /*
class Property_Port implements IPort {
	var property:Property;

	public var connections = new Array<IPort>();

	public function new(property:Property) {
		this.property = property;
	}

  public function connect(other:IPort) {
    this.connections.push(other);
    other.connections.push(this);
  }

	public function get_type():Kind {
		return property.type;
	}

	public function get_value(context:Context):Dynamic {
		return context.node.get_value(property.id);
	}

	public function set_value(value:Dynamic, context:Context):Dynamic {
		context.node.set_value(property.id, value);
		return value;
	}

	public function output(value:Dynamic, context:Context) {
    for (other in connections) {
      value = other.set_value(value, context);
    }

		return value;
	}
}*/