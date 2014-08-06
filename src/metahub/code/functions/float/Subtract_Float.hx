package metahub.code.functions.float;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Subtract_Float extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		var first:Float = cast args[0], second:Float = cast args[1];
    return first - second;
	}
}