package metahub.code.functions.float;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Add_Float extends Function{

	override private function forward(args:Array<Dynamic>):Dynamic {
		var total:Float = 0;
    for (arg in args) {
			var value:Float = cast arg;
      total += value;
    }

    return total;
	}
}