package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Greater_Than_Int extends Function {
	override private function forward(args:Array<Dynamic>):Dynamic {
		return reverse(args[0], [args[1]]);
		//var first:Int = cast args[0]
		//return first > second
			//? first
			//: second;
	}

	override private function reverse(new_value:Dynamic, args:Array<Dynamic>):Dynamic {
		var first:Int = cast new_value, second:Int = cast args[0];
		return first > second
			? first
			: second;
	}
}