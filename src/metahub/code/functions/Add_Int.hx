package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Add_Int extends Function{

	override private function forward(args:Array<Dynamic>):Dynamic {
		var total:Int = 0;
    for (arg in args) {
			var value:Int = cast arg;
      total += value;
    }

    return total;
	}
}