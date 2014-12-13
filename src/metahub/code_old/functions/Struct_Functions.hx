package metahub.code.functions;
import metahub.schema.Kind;

import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Struct_Functions extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		switch (cast func) {
			case Functions.add:
				return add_forward(args);

			case Functions.subtract:
				return subtract_forward(args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	override private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		return new_value;
	}

	function add_forward(args:Array<Dynamic>) {
		var trellis = signature[0].trellis;
		var result = hub.create_node(trellis);
		var nodes:Array<Node> = cast args;

		for (i in 0...(trellis.properties.length - 1)) {
			var property = trellis.properties[i];

			if (property.type == Kind.int) {
				var value:Int = result.get_value(property.id);
				for (node in nodes) {
					value += node.get_value(property.id);
				}
				result.set_value(property.id, value);
			}

			if (property.type == Kind.float) {
				var value:Float = result.get_value(property.id);
				for (node in nodes) {
					value += node.get_value(property.id);
				}
				result.set_value(property.id, value);
			}
		}

		return result;
	}

	function subtract_forward(args:Array<Dynamic>):Dynamic {
		var first:Float = cast args[0], second:Float = cast args[1];
    return first - second;
	}

}