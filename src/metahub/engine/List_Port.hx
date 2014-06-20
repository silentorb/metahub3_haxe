package metahub.engine;

import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.Functions;
import metahub.schema.Types;

class List_Port extends Base_Port<Array<Dynamic>> {

	public function new(node:INode, hub:Hub, property:Property, value:Dynamic = null) {
		if (value == null)
			value = new Array<Dynamic>();

		super(node, hub, property, value);
  }

	public function get_array():Array<Dynamic> {
    return _value;
  }

  public function get_value_at(index:Int):Dynamic {
    return _value[index];
  }

	public function set_value_at(new_value:Dynamic, index:Int):Dynamic {
    return _value[index] = new_value;
  }

  public function add_value(new_value:Dynamic) {
    _value.push(new_value);
		trace('list changed.');
		update_property_dependents();
  }

	//override public function get_value(context:Context = null):Dynamic {
    //throw new Exception("Not supported.");
  //}

  override public function set_value(new_value:Dynamic, context:Context = null):Dynamic {
    throw new Exception("Not supported.");
  }

	/*
  var values = new Array<Dynamic>();
  public var property:Property;
  public var parent:INode;
  public var dependencies = new Array<IPort>();
  public var dependents = new Array<IPort>();
  var _action:Functions = Functions.none;
  public var action(get, set):Functions;
	public function get_action():Functions {
		return _action;
	}
	public function set_action(value):Functions {
		return _action = value;
	}

  public function new(node:Node, property:Property) {
    this.parent = node;
    this.property = property;
  }

	public function get_type():Types {
		return property.type;
	}

  public function get_value_at(index:Int):Dynamic {
    return values[index];
  }

	public function get_value():Dynamic {
    return values;
  }

  public function set_value(new_value:Dynamic, context:Context = null):Dynamic {
    return values = new_value;
  }

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }
*/
}