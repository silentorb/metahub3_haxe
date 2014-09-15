package metahub.code.functions;
import metahub.code.nodes.Property_Node;
import metahub.engine.Context;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Count extends Function {

	override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	override private function forward(args:Array<Dynamic>):Dynamic {
		return args[0].length;
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		var length:Int = value;
		var old:Array<Dynamic> = args[0];
		if (old.length == length) {
			return old;
		}

		if (old.length > length) {
			throw new Exception("Not yet implemented.");
		}

		var result = old.copy();
		var discrepancy = length - result.length;
		for (i in 0...discrepancy) {
			var node = this.hub.create_node(this.signature[1].trellis);
			result.push(node);
		}

		return result;
	}

	override public function resolve_token(value:Dynamic):Dynamic {
		var list:Array<Dynamic> = cast value;
		if (list.length == 0)
			return 0;

		return list.length;
	}

	override public function set_token_value(value:Dynamic, previous:Dynamic, context:Context) {
		var length:Int = value;
		var old:Array<Dynamic> = previous;
		if (old.length == length)
			return;

		if (old.length > length) {
			throw new Exception("Not yet implemented.");
		}

		var result = old.copy();
		var discrepancy = length - result.length;
		for (i in 0...discrepancy) {
			var node = this.hub.create_node(this.signature[1].trellis);
			result.push(node);
		}

		for (other in ports[1].connections) {
			context.hub.add_change(other.node, other.id, result, context, ports[1]);
		}
	}
}