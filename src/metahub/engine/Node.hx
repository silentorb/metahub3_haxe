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
	//public var port_count(get, null):Int;

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

		//var properties = trellis.get_all_properties();

    for (property in trellis.properties) {
			values.push(get_default_value(property));
			if (property == trellis.identity_property)
				continue;

      //values.push(property.get_default());
      //var port = new Port(this, property.id);
      //ports.push(port);
    }

    //initialize();
  }

	//private function initialize() {
//
	//}
	//public function get_port_count():Int {
		//return ports.length;
	//}

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
/*
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
*/
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

  public function set_value(index:Int, value:Dynamic, source:General_Port = null) {
		var property = trellis.properties[index];
		//if (property.type == Kind.pulse) {
			//update_trellis_connections(index, value, source);
			//return;
		//}

		var old_value = values[index];
		var port = ports[index];
		//if (property.type == Kind.list)
			//throw new Exception(property.fullname() + " is a list and cannot be directly assigned to.");

		if (equals(old_value, value, property)) {
			#if log
			hub.history.log("attempted " + property.fullname() + "|set_value " + value);
			#end
			return;
		}
		//if (this.trellis.name == "Position" && this.values[2] != 0 && this.values[2].trellis.name == "Body") {
			//var x1 = 1;
		//}
		hub.set_entry_node(this);

		if (property.other_trellis != null && property.other_trellis.is_value) {
			var mine:Node = old_value;
			var other:Node = value;
			other.copy(mine);
		}
		else {
			values[index] = value;
		}

		#if log
		hub.history.log(property.fullname() + "|set_value " + value);
		#end

		update_trellis_connections(index, value, source);

		if (property.type == Kind.reference && !property.other_trellis.is_value) {
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

  //public function pulse(index:Int) {
		//var property = trellis.properties[index];
		//if (property.type != Kind.pulse)
			//throw new Exception("Property " + property.fullname() + " is not a pulse.");
//
		//var port = trellis.get_port(index);
		//for (other in port.connections) {
			//var block:Block_Node = cast other.node;
			//block.run();
		//}
	//}

	public function copy(target:Node) {
		for (i in 0...(trellis.properties.length - 1)) {
			target.set_value(i, get_value(i));
		}
	}

}