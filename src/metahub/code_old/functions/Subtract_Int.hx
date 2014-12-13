package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Subtract_Int extends Function{

	override private function forward(args:Array<Dynamic>):Dynamic {
		var first:Int = cast args[0], second:Int = cast args[1];
    return first - second;
	}
}