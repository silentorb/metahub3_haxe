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
  var ports = new Array<General_Port>();
	var func:Functions;
	public var id:Identity;
	var signature:Array<Type_Signature>;

	public function new(hub:Hub, id:Identity, func:Functions, signature:Array<Type_Signature>) {
    this.hub = hub;
    this.id = id;
		this.func = func;
		this.signature = signature;

		for (type in signature) {
			var port = new General_Port(this, ports.length);
      ports.push(port);
		}
	}

	public function get_value(index:Int, context:Context):Dynamic {
		if (index == 0)
			return run_forward(context);
		else
			throw new Exception("Not implemented.");
	}

	public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (source == ports[0]) {
			for (i in 0...ports.length) {
				ports[i].set_external_value(value, context);
			}
			return;
		}

		if (index == 1) {
			var new_value = run_forward(context);
			//if (new_value != value) {
				//hub.add_change(this, index, new_value, context, ports[0]);
			//}
			//else {
			ports[0].set_external_value(new_value, context);
			//}
		}
		else {
			var new_value = run_reverse(value, context);
			if (new_value != value) {
				hub.add_change(this, index, new_value, context, ports[0]);
			}
			else {
				for (i in 1...ports.length) {
					ports[i].set_external_value(new_value, context);
				}
			//throw new Exception("Not implemented 367.");
			}
		}
	}

  public function get_inputs():Array<General_Port> {
		return ports.slice(1);
  }

  public function get_port(index:Int):General_Port {
#if debug
  if ((index < 0 && index >= ports.length) || ports[index] == null)
  throw new Exception("Node " + Std.string(func) + " does not have a property index of " + index + ".");
#end
    return ports[index];
  }

	public function get_input_values(context:Context):Array<Dynamic> {
		var result = new Array<Dynamic>();
		for (i in 1...ports.length) {
			var port:General_Port = cast get_port(i);
			result.push(port.get_external_value(context));
		}
		return result;
	}

	function run_forward(context:Context):Dynamic {
   var args = get_input_values(context);
		context.hub.history.log("function " + Std.string(func) + " forward()" + args);
		return forward(args);

    //var result = Function_Calls.call(trellis.name, args, ports[0].get_type());
		//ports[0].set_value(result, context);
	}

	function run_reverse(value:Dynamic, context:Context) {
		context.hub.history.log("function " + Std.string(func) + " reverse()");
		//throw new Exception("Function.run_reverse Not implemented.");

		return reverse(value, get_input_values(context));
	}

	private function forward(args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.forward is abstract.");
	}

	private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.reverse is abstract.");
	}

}