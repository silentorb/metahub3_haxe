package metahub.engine;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.schema.Property_Chain;
import metahub.schema.Kind;
import metahub.code.functions.Functions;

typedef Identity = UInt;

class Node implements INode {
  public var hub:Hub;
  //var values = new Array<Dynamic>();
  var ports = new Array<IPort>();
  public var id:Identity;
  var trellis:Trellis;
	public var port_count(get, null):Int;
	public function get_port_count():Int {
		return ports.length;
	}

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

		var properties = trellis.get_all_properties();

    for (property in properties) {
			if (property == trellis.identity_property)
				continue;

      //values.push(property.get_default());
      var port = property.type == Kind.list
      ? new List_Port(this, hub, property)
      : new Port(this, hub, property, property.get_default());
      ports.push(port);
    }

    initialize();
  }

	private function initialize() {

	}

  public function get_inputs():Array<IPort> {
		var properties = trellis.get_all_properties();
    var result = new Array<IPort>();
    for (property in properties) {
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

		var current_node:INode = this;
		var i = 0;
		for (link in chain) {
			var port = current_node.get_port(link.id);
			if (link.type == Kind.reference) {
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
    return port.get_value(null);
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    var port:Port = cast ports[property.id];
    return port.get_value(null);
  }

  public function set_value(index:Int, value:Dynamic) {
    var port:Port = cast ports[index];
    port.set_value(value, null);
  }

	public function get_input_values(context:Context):Array<Dynamic> {
		var result = new Array<Dynamic>();
		for (i in 1...ports.length) {
			var port:Port = cast get_port(i);
			var value = port.property.multiple
			? port.connections.map(function(d) { return d.get_value(context); } )
			: //port.get_value(context);
				port.connections[0].get_value(context);
			//var value = get_port(i).get_value();
			result.push(value);
		}
		return result;
	}

  public function add_list_value(index:Int, value:Dynamic) {
    var port:List_Port = cast ports[index];
    port.add_value(value);
  }
}