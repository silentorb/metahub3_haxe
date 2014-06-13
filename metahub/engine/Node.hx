package engine;
import schema.Trellis;
import schema.Property;
import schema.Property_Chain;
import schema.Types;
import code.Functions;

typedef Identity = UInt;

class Node implements INode {
  public var hub:Hub;
  var values = new Array<Dynamic>();
  var ports = new Array<IPort>();
  public var id:Identity;
  var trellis:Trellis;
//  var dependencies = new Array<Dependency>();
//  var dependents = new Array<Dependency>();
	public var port_count(get, null):Int;
	public function get_port_count():Int {
		return ports.length;
	}

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

    for (property in trellis.properties) {
      values.push(property.get_default());
      var port = property.type == Types.list
      ? new List_Port(this, property)
      : new Port(this, hub, property, property.get_default());
      ports.push(port);
    }

    if (trellis.is_a(hub.schema.get_trellis("function"))) {
			initialize_function();
		}
  }

	function initialize_function() {
		var inputs = get_inputs();
		for (i in inputs) {
			var input:Port = cast i;
			input.on_change.push(run_function);
		}
	}

	function run_function(input:Port, value:Dynamic, context:Context) {
    var args = get_input_values();
		var action = Type.createEnum(Functions, trellis.name);
    var result = Function_Calls.call(action, args, ports[0].get_type());
		ports[0].set_value(result, context);
	}

  public function get_inputs():Array<IPort> {
    var result = new Array<IPort>();
    for (property in trellis.properties) {
      if (property.name != "output") {
        result.push(get_port(property.id));
      }
    }

    return result;
  }

  public function get_port(index:Int):IPort {
#if debug
  if ((index < 0 && index >= ports.length) || ports[index] == null)
  throw new Exception("Node " + trellis.name + " does not have a property index of " + index + ".");
#end
    return ports[index];
  }

  public function get_port_by_name(name:String):IPort {
    var property = trellis.get_property(name);
    return get_port(property.id);
  }

	public function get_port_from_chain(chain:Property_Chain):IPort {
		if (chain.length == 0)
			throw new Exception("Cannot follow empty property chain.");

		var current_node = this;
		var i = 0;
		for (link in chain) {
			var port = current_node.get_port(link.id);
			if (link.type == Types.reference) {
				var reference:Port = cast port;
				current_node = reference.get_other_node();
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
    var port:Port = cast get_port(index);
    return port.get_value();
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    var port:Port = cast ports[property.id];
    return port.get_value();
  }

  public function set_value(index:Int, value:Dynamic) {
    var port:Port = cast ports[index];
    port.set_value(value);
  }

	public function get_input_values():Iterable<Dynamic> {
		var result = new Array<Dynamic>();
		for (i in 1...ports.length) {
			var value = get_port(i).get_value();
			result.push(value);
		}
		return result;
	}

  public function add_list_value(index:Int, value:Dynamic) {
    var port:List_Port = cast ports[index];
    port.add_value(value);
  }
}