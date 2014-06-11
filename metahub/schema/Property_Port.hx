package schema;
import engine.IPort;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Property_Port implements IPort {
	var property:Property;
	var origin:Property_Chain;

	public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();

	public function new(property:Property) {
		this.property = property;
	}

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }

	public function get_type():Types {
		return property.type;
	}

	public function get_value():Dynamic {
		throw new Exception("Not implemented.");
	}

	public function set_value(value:Dynamic):Dynamic {
		update_dependents(value);
		return value;
	}

	public function update_dependents(value:Dynamic) {
    for (other in dependents) {
      other.set_value(value);
    }
  }
}