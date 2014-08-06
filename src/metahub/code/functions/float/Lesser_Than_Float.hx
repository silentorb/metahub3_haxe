package metahub.code.functions.float;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Lesser_Than_Float extends Function {
	override private function forward(args:Array<Dynamic>):Dynamic {
		throw new Exception("Lesser_Than_Float.forward() is not yet implemented.");
		//var first:Float = cast args[0]
		//return first > second
			//? first
			//: second;
	}

	override private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Float = cast new_value, second:Float = cast args[0];
		return first < second
			? first
			: second;
	}
}