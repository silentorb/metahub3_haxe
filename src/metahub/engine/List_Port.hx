package metahub.engine;

import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.functions.Functions;
import metahub.schema.Types;

class List_Port extends Port {

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
		update_property_connections(new_value, null);
  }

	//override public function get_value(context:Context = null):Dynamic {
    //throw new Exception("Not supported.");
  //}

  override public function set_value(new_value:Dynamic, context:Context = null):Dynamic {
    throw new Exception("Not supported.");
  }
}