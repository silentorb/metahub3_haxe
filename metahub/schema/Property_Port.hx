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

	public function get_value():Dynamic {
		throw new Exception("Not implemented.");
	}
}