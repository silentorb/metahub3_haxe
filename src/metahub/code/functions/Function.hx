package metahub.code.functions;
import metahub.code.nodes.Group;
import metahub.code.nodes.IToken_Node;
import metahub.code.nodes.Standard_Node;
import metahub.engine.*;
import metahub.schema.Trellis;

typedef Identity = UInt;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function extends Standard_Node implements IToken_Node {
	public var hub:Hub;
	var func:Functions;
	var signature:Array<Type_Signature>;

	public function new(hub:Hub, func:Functions, signature:Array < Type_Signature > , group:Group) {
		super(group);
    this.hub = hub;
		this.func = func;
		this.signature = signature;

		add_ports(signature.length);
	}

	override public function get_value(index:Int, context:Context):Dynamic {
		if (index == 0)
			return run_forward(context);
		else
			throw new Exception("Not implemented.");
	}

	override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (group.is_back_referencing)
			return;

		if (index > 0) {
			var new_value = run_forward(context);
			ports[0].set_external_value(new_value, context);
		}
		else {
			var new_value = run_reverse(value, context);
			if (new_value != value) {
				hub.add_change(this, index, new_value, context, ports[0]);
			}
			//else {
				//for (i in 1...ports.length) {
					//ports[i].set_external_value(new_value, context);
				//}
			//}
		}
	}

  public function get_inputs():Array<General_Port> {
		return ports.slice(1);
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
		#if log
		context.hub.history.log("function " + Std.string(func) + " forward()" + args);
		#end
		return forward(args);
	}

	function run_reverse(value:Dynamic, context:Context) {
		#if log
		context.hub.history.log("function " + Std.string(func) + " reverse()");
		#end

		return reverse(value, get_input_values(context));
	}

	private function forward(args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.forward is abstract.");
	}

	private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		throw new Exception("Function.reverse is abstract.");
	}

	override public function to_string():String {
		return Std.string(func);
	}

  public function resolve_token(value:Dynamic):Dynamic {
		throw new Exception("Not implemented.");
	}

  public function resolve_token_reverse(value:Dynamic, previous:Dynamic):Dynamic {
		throw new Exception("Not implemented.");
	}

  public function set_token_value(value:Dynamic, previous:Dynamic, context:Context) {
		throw new Exception("Not implemented.");
	}

	override public function resolve(context:Context):Context {
		return context;
	}

}