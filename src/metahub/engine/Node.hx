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
	public var port_count(get, null):Int;

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

		var properties = trellis.get_all_properties();

    for (property in properties) {
			values.push(get_default_value(property));
			if (property == trellis.identity_property)
				continue;

      //values.push(property.get_default());
      var port = new Port(this, property.id);
      ports.push(port);
    }

    initialize();
  }

	private function initialize() {

	}
	public function get_port_count():Int {
		return ports.length;
	}

	public function get_default_value(property:Property):Dynamic {
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
					var parent_property = property.other_trellis.get_property("parent");
					if (parent_property != null)
						node.set_value(parent_property.id, id, null);

					return node.id;
				}
				return 0;

			case Kind.string:
				return "";

			case Kind.bool:
				return false;

			case Kind.pulse:
				return null;

			default:
				throw new Exception("No default is implemented for type " + property.type + ".");
		}
	}

  public function get_inputs():Array<Port> {
		var properties = trellis.get_all_properties();
    var result = new Array<Port>();
    for (property in properties) {
      if (property.name != "output") {
        result.push(get_port(property.id));
      }
    }

    return result;
  }

  public function get_port(index:Int):Port {
#if debug
  if ((index < 0 && index >= ports.length) || ports[index] == null)
  throw new Exception("Node " + trellis.name + " does not have a property index of " + index + ".");
#end
    return ports[index];
  }

  public function get_port_by_name(name:String):Port {
    var property = trellis.get_property(name);
    return get_port(property.id);
  }

	//public function get_port_from_chain(chain:Path):Port {
		//if (chain.length == 0)
			//throw new Exception("Cannot follow empty property chain.");
//
		//var current_node = this;
		//var i = 0;
		//for (link in chain) {
			//if (link.type == Kind.reference) {
				//current_node = hub.get_node(link.id);
			//}
			//else {
				//if (i < chain.length - 1)
					//throw new Exception('Invalid chain. ' + link.fullname() + ' is not a reference.');
//
				//return current_node.get_port(link.id);
			//}
//
			//++i;
		//}
//
		//throw new Exception('Could not follow chain');
	//}

  public function get_value(index:Int):Dynamic {
    return values[index];
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    return values[property.id];
  }

	function equals(first:Dynamic, second:Dynamic, property:Property):Bool {
		if (property.other_trellis != null && property.other_trellis.is_value) {
			var first_node = hub.get_node(first);
			var second_node = hub.get_node(second);
			var properties = property.other_trellis.properties;
			for (i in 0...properties.length) {
				if (!equals(first_node.get_value(i), second_node.get_value(i), properties[i]))
					return false;
			}
			return true;
		}
		else {
			return first == second;
		}
	}

  public function set_value(index:Int, value:Dynamic, source:General_Port = null) {
		var property = trellis.properties[index];
		if (property.type == Kind.pulse) {
			update_trellis_connections(index, value, source);
			return;
		}

		var old_value = values[index];
		var port = ports[index];
		if (property.type == Kind.list)
			throw new Exception(property.fullname() + " is a list and cannot be directly assigned to.");

		if (equals(old_value, value, property)) {
			hub.history.log("attempted " + property.fullname() + "|set_value " + value);
			return;
		}

		hub.set_entry_node(this);

		if (property.other_trellis != null && property.other_trellis.is_value) {
			var mine = hub.get_node(old_value);
			var other = hub.get_node(value);
			other.copy(mine);
		}
		values[index] = value;
		hub.history.log(property.fullname() + "|set_value " + value);

		update_trellis_connections(index, value, source);

		if (property.type == Kind.reference && !property.other_trellis.is_value) {
			var other_node = hub.get_node(value);
      if (property.other_property.type == Kind.list) {
				var list:Array<Dynamic> = other_node.get_value(property.other_property.id);
				if (list.indexOf(id) == -1)
					other_node.add_item(property.other_property.id, id);
      }
      else {
				if (other_node.get_value(property.other_property.id) != id)
					other_node.set_value(property.other_property.id, id, source);
      }
    }

		hub.run_change_queue(this);
  }

	function update_trellis_connections(index:Int, value:Dynamic, source:General_Port = null) {
		var context = new Node_Context(this, hub);
		var tree = trellis.get_tree();
		for (t in tree) {
			if (t.properties.length > index)
				t.set_external_value(index, value, context, source);
		}
	}

	public function add_item(index:Int, value:Dynamic) {
		var port = ports[index];
		var property = trellis.properties[index];
		if (property.type != Kind.list)
			throw new Exception("Cannot add items to " + property.fullname + " because it is not a list.");

		var list:Array<Dynamic> = cast values[index];
		list.push(value);
		hub.history.log(property.fullname() + "|add_item " + value);

		var context = new Node_Context(this, hub);
		trellis.set_external_value(index, list, context, null);

		if (property.other_property.type == Kind.reference) {
			var other_node = hub.get_node(value);
			if (other_node.get_value(property.other_property.id) != id)
				other_node.set_value(property.other_property.id, id);
		}
		else {
			throw new Exception("Not implemented.");

		}
  }

  public function pulse(index:Int) {
		var property = trellis.properties[index];
		if (property.type != Kind.pulse)
			throw new Exception("Property " + property.fullname() + " is not a pulse.");

		var port = trellis.get_port(index);
		for (other in port.connections) {
			var block:Block_Node = cast other.node;
			block.run();
		}
	}

	public function copy(target:Node) {
		for (i in 0...trellis.properties.length) {
			target.set_value(i, get_value(i));
		}
	}

}