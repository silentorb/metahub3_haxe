package metahub.code.functions;
import metahub.engine.*;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function extends Node {

	override function initialize() {
		super.initialize();

		var properties = trellis.get_all_properties();
		for (property in properties) {
      var port:Port = cast get_port(property.id);
      if (property.name != "output") {
				port.on_change.push(run_forward);
      }
			else {
				port.on_change.push(run_reverse);
			}
    }
	}

  public function get_outputs():Array<IPort> {
		var properties = trellis.get_all_properties();
    var result = new Array<IPort>();
    for (property in properties) {
      if (property.name == "output") {
        result.push(get_port(property.id));
      }
    }

    return result;
  }

	function run_forward<T>(input:Port, value:T, context:Context) {
    var args = get_input_values(context);
		return forward(args);
    //var result = Function_Calls.call(trellis.name, args, ports[0].get_type());
		//ports[0].set_value(result, context);
	}

	function run_reverse<T>(input:Port, value:T, context:Context) {
    //var args = [
			//value,
			//get_outputs()[0].get_value(context)
		//];
		var new_value = reverse(value, get_input_values(context));
		if (new_value != value) {
			input.set_value(new_value, context);
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