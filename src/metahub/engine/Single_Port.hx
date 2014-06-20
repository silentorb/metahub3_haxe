package metahub.engine;

import metahub.schema.Property;
import metahub.code.Functions;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Single_Port<T> {
  public var property:Property;
  public var node:Node;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
  public var action:Functions = Functions.none;

	public function get_value():Dynamic {
    return value;
  }

  public function set_value(new_value:Dynamic) {
    if (value == new_value)
      return;

    value = new_value;
    if (this.dependents != null && this.dependents.length > 0) {
      update_dependents();
    }

		if (property.dependents != null && this.dependents.length > 0) {
			update_property_dependents();
		}

    if (action != Functions.none)
      Function_Calls.call(action, this.node);
  }
}