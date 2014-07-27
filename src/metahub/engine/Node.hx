package metahub.engine;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.schema.Property_Chain;
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
				return 0;

			case Kind.string:
				return "";

			case Kind.bool:
				return false;
				
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

	public function get_port_from_chain(chain:Property_Chain):Port {
		if (chain.length == 0)
			throw new Exception("Cannot follow empty property chain.");

		var current_node = this;
		var i = 0;
		for (link in chain) {
			if (link.type == Kind.reference) {
				current_node = hub.get_node(link.id);
			}
			else {
				if (i < chain.length - 1)
					throw new Exception('Invalid chain. ' + link.fullname() + ' is not a reference.');

				return current_node.get_port(link.id);
			}

			++i;
		}

		throw new Exception('Could not follow chain');
	}

  public function get_value(index:Int):Dynamic {
    return values[index];
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    return values[property.id];
  }

  public function set_value(index:Int, value:Dynamic, source:General_Port = null) {
		var old_value = values[index];
		var port = ports[index];
		var property = trellis.properties[index];
		if (property.type == Kind.list)
			throw new Exception(property.fullname() + " is a list and cannot be directly assigned to.");
		
		if (!property.multiple && old_value == value) {
			hub.history.log("attempted " + property.fullname() + "|set_value " + value);
			return;
		}

		values[index] = value;
		hub.history.log(property.fullname() + "|set_value " + value);
		
		var context = new Context(this, hub);
		trellis.set_external_value(index, value, context, source);
		
		if (property.type == Kind.reference) {
      if (property.other_property.type == Kind.list) {
        var other_node = hub.get_node(value);
				other_node.add_item(property.other_property.id, id);
      }
      else {
				throw new Exception("Not implemented.");

      }
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
		
		var context = new Context(this, hub);
		trellis.set_external_value(index, value, context, null);
		
		if (property.other_property.type == Kind.reference) {
			var other_node = hub.get_node(value);
			if (other_node.get_value(property.other_property.id) != id)
				other_node.set_value(property.other_property.id, id);
		}
		else {
			throw new Exception("Not implemented.");

		}
  }

}