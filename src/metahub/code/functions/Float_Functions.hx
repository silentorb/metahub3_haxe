package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Float_Functions extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		switch (func) {
			case Functions.add:
				return add_forward(args);

			case Functions.subtract:
				return subtract_forward(args);

			case Functions.multiply:
				return multiply_forward(args);

			case Functions.divide:
				return divide_forward(args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		switch (func) {
			case Functions.lesser_than:
				return lesser_than_reverse(value, args);

			case Functions.lesser_than_or_equal_to:
				return lesser_than_or_equal_to_reverse(value, args);

			case Functions.greater_than:
				return greater_than_reverse(value, args);

			case Functions.greater_than_or_equal_to:
				return greater_than_or_equal_to_reverse(value, args);

			default:
				throw new Exception("Invalid function.");

		}
	}

	function add_forward(args:Array<Dynamic>) {
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

	function multiply_forward(args:Array<Dynamic>):Dynamic {
		var first:Float = cast args[0], second:Float = cast args[1];
    return first * second;
	}

	function divide_forward(args:Array<Dynamic>):Dynamic {
		var first:Float = cast args[0], second:Float = cast args[1];
    return first / second;
	}

	private function lesser_than_reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Int = cast new_value, second:Int = cast args[0];
		return first < second
			? first
			: second - 0.0000001;
	}

	private function lesser_than_or_equal_to_reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Int = cast new_value, second:Int = cast args[0];
		return first <= second
			? first
			: second;
	}

	private function greater_than_reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Int = cast new_value, second:Int = cast args[0];
		return first > second
			? first
			: second + 0.0000001;
	}

	private function greater_than_or_equal_to_reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Int = cast new_value, second:Int = cast args[0];
		return first >= second
			? first
			: second;
	}
}