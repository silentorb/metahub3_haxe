package metahub.code.functions;
import metahub.engine.*;
import metahub.schema.Trellis;

typedef Identity = UInt;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function implements INode {
	public var hub:Hub;
  var ports = new Array<Signal_Port>();
  var trellis:Trellis;
	public var id:Identity;

	public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

		var properties = trellis.get_all_properties();

    for (property in properties) {
			if (property == trellis.identity_property)
				continue;

      var port = new Signal_Port(property.type);
      ports.push(port);
    }
		var properties = trellis.get_all_properties();
		for (property in properties) {
      var port:Signal_Port = cast get_port(property.id);
      if (property.name != "output") {
				port.on_change.push(run_forward);
      }
			else {
				port.on_change.push(run_reverse);
			}
    }
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

	public function get_input_values(context:Context):Array<Dynamic> {
		var result = new Array<Dynamic>();
		for (i in 1...ports.length) {
			var port:Port = cast get_port(i);
			result.push(port.get_value(context));
		}
		return result;
	}

	function run_forward<T>(input:Signal_Port, value:T, context:Context) {
    var args = get_input_values(context);
		return forward(args);
    //var result = Function_Calls.call(trellis.name, args, ports[0].get_type());
		//ports[0].set_value(result, context);
	}

	function run_reverse<T>(input:Signal_Port, value:T, context:Context) {
    //var args = [
			//value,
			//get_outputs()[0].get_value(context)
		//];
		var new_value = reverse(value, get_input_values(context));
		if (new_value != value) {
			input.output(new_value, context);
		}
    //var result = Function_Calls.call(trellis.name, args, ports[0].get_type());
		//ports[0].set_value(result, context);
	}

	private function forward(args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.forward is abstract.");
	}

	private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.reverse is abstract.");
	}
}