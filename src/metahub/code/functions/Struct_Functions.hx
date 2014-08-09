package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Struct_Functions extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		switch (func) {
			case Functions.add:
				return add_forward(args);

			case Functions.subtract:
				return subtract_forward(args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	function add_forward(args:Array<Dynamic>) {
		var trellis = signature[0].trellis;
		trellis.total =
		var total:Float = 0;
		for (arg in args) {
			var value:Float = cast arg;
			total += value;
		}

		return total;
	}

	function subtract_forward(args:Array<Dynamic>):Dynamic {
		var first:Float = cast args[0], second:Float = cast args[1];
    return first - second;
	}
}