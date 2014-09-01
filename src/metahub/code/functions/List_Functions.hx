package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class List_Functions extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		var first:Array<Dynamic> = args[0];
		var second:Dynamic = args[1];

		switch (func) {
			case Functions.add:
				return first.concat([second]);

			case Functions.first:
				return first.length > 0 ? first[0] : null;

			default:
				throw new Exception("Invalid function.");

		}

		return first;
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		switch (func) {

			default:
				throw new Exception("Invalid function.");

		}
		return null;
	}
}