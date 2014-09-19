package metahub.engine;
import metahub.code.nodes.Block_Node;
import metahub.code.Path;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.schema.Kind;
import metahub.code.functions.Functions;

typedef Identity = Int;

class Node {
  public var hub:Hub;
  var values = new Array<Dynamic>();
  var ports = new Array<Port>();
  public var id:Identity;
  public var trellis:Trellis;
	public var this_context:Context;
	//public var port_count(get, null):Int;

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

    for (property in trellis.properties) {
			values.push(get_default_value(property));
			//if (property == trellis.identity_property)
				//continue;
    }

		this_context = new Node_Context(this, hub);
  }

	public function get_default_value(property:Property):Dynamic {
		if (property.default_value != null)
			return property.default_value;

		switch (property.type)
		{
			case Kind.list:
				return new Array<Dynamic>();

			case Kind.int:
				return 0;

			case Kind.float:
				return 0.0;

			case Kind.reference:
				if (property.other_trellis.is_value) {
					var node = hub.create_node(property.other_trellis);
					node.set_value(property.other_trellis.properties.length - 1, this, null);
					return node;
				}
				return null;

			case Kind.string:
				return "";

			case Kind.bool:
				return false;

			//case Kind.pulse:
				//return null;

			case Kind.unknown:
				return null;

			default:
				throw new Exception("No default is implemented for type " + property.type + ".");
		}
	}
//
	//public function initialize_values2() {
		//for (property in trellis.properties) {
			//input_trellis_connections(property.id);
		//}
	//}

	public function update_values() {
		for (property in trellis.properties) {
			update_value(property, values[property.id]);
		}
	}

  public function get_value(index:Int):Dynamic {
    return values[index];
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    return values[property.id];
  }

	function equals(first:Dynamic, second:Dynamic, property:Property):Bool {
		if (first == second)
			return true;


		if (property.other_trellis != null && property.other_trellis.is_value) {
			if (first == null || second == null)
				return false;

			var first_node:Node = first;
			var second_node:Node = second;
			var properties = property.other_trellis.properties;
			for (i in 0...(properties.length - 1)) {
				if (!equals(first_node.get_value(i), second_node.get_value(i), properties[i]))
					return false;
			}
			return true;
		}

		return false;
	}

	function copy_list(index:Int, new_list:Array<Dynamic>, old_list:Array<Dynamic>) {
		for (item in new_list) {
			if (old_list.indexOf(item) == -1) {
				add_item(index, item);
			}
		}
	}

  public function set_value(index:Int, value:Dynamic, source:General_Port = null) {
		var property = trellis.properties[index];
		var old_value = values[index];
		var port = ports[index];
		if (property.type == Kind.list) {
			copy_list(index, cast value, cast old_value);
			return;
		}

		if (equals(old_value, value, property)) {
			#if log
			hub.history.log("attempted " + property.fullname() + "|set_value " + value);
			#end
			return;
		}

		//if (property.type == Kind.int && Type.typeof(value).getName() != 'TInt')
			//throw new Exception("Invalid assignment to integer.");

		if (property.other_trellis != null && property.other_trellis.is_value) {
			var mine:Node = cast old_value;
			var other:Node = cast value;
			other.copy_without_update(mine);
			update_value(property, old_value, source);
		}
		else {
			values[property.id] = value;
			update_value(property, value, source);
		}

		if (trellis.is_value) {
			var parent:Node = values[this.values.length - 1];
			if (parent != null) {
				for (property in parent.trellis.properties) {
					if (property.other_trellis == trellis && parent.get_value(property.id) == this) {
						parent.update_value(property, this);
						break;
					}
				}
			}
		}
  }

	function update_value(property:Property, value:Dynamic, source:General_Port = null) {
		hub.set_entry_node(this);

		if (property.other_trellis != null && property.other_trellis.is_value) {
			var other:Node = cast value;
			other.update_values();
		}

		#if log
		hub.history.log(property.fullname() + "|set_value " + value);
		#end

		ouput_trellis_connections(property.id, value, source);

		if (property.type == Kind.reference && !property.other_trellis.is_value && value != null) {
			var other_node:Node = value;
      if (property.other_property.type == Kind.list) {
				var list:Array<Dynamic> = other_node.get_value(property.other_property.id);
				if (list.indexOf(this) == -1)
					other_node.add_item(property.other_property.id, this);
      }
      else {
				if (other_node.get_value(property.other_property.id) != this)
					other_node.set_value(property.other_property.id, this, source);
      }
    }

		hub.run_change_queue(this);
	}

	function ouput_trellis_connections(index:Int, value:Dynamic, source:General_Port = null) {
		var tree = trellis.get_tree();
		for (t in tree) {
			if (t.properties.length > index)
				t.set_external_value(index, value, this_context, source);
		}
	}

	public function update_on_create() {
		var tree = trellis.get_tree();
		for (t in tree) {
			t.on_create_node(this_context);
		}
	}

	//function input_trellis_connections(index:Int) {
		//var tree = trellis.get_tree();
		//for (t in tree) {
			//if (t.properties.length > index) {
				//var value = t.get_value(index, this_context);
				//if (!equals(value, values[index], trellis.properties[index])) {
					//values[index] = value;
				//}
			//}
		//}
	//}

	public function add_item(index:Int, value:Dynamic) {
		var port = ports[index];
		var property = trellis.properties[index];
		if (property.type != Kind.list)
			throw new Exception("Cannot add items to " + property.fullname + " because it is not a list.");

		var list:Array<Dynamic> = cast values[index];
		list.push(value);
		#if log
		hub.history.log(property.fullname() + "|add_item " + value);
		#end

		var context = new Node_Context(this, hub);
		trellis.set_external_value(index, list, context, null);

		if (property.other_property.type == Kind.reference) {
			var other_node:Node = value;
			if (other_node.get_value(property.other_property.id) != this)
				other_node.set_value(property.other_property.id, this);
		}
		else {
			throw new Exception("Not implemented.");

		}
  }

	public function copy_without_update(target:Node) {
		for (i in 0...(trellis.properties.length - 1)) {
			//target.set_value(i, get_value(i));
			target.values[i] = get_value(i);
		}
	}

}