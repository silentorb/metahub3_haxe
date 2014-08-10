package metahub.code.functions;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Struct_Float_Functions extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		switch (func) {
			case Functions.multiply:
				return multiply_float_forward(args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		switch (func) {
			case Functions.multiply:
				return multiply_float_reverse(value, args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	function multiply_float_forward(args:Array<Dynamic>) {
		var trellis = signature[0].trellis;
		var result = hub.create_node(trellis);
		var node:Node = args[0];
		var modifier:Float = args[1];

		for (i in 0...(trellis.properties.length - 1)) {
			var property = trellis.properties[i];
			var value:Float = node.get_value(property.id);
			result.set_value(property.id, value *= modifier);
		}

		return result;
	}

	private function multiply_float_reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		return value;
	}

}