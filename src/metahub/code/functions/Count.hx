package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Count extends Function{

	override private function forward(args:Array<Dynamic>):Dynamic {
		return args[0].length;
	}
}