package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function {

	public function run(args:List<Dynamic>):Dynamic {
		throw new Exception("Function.forward is abstract.");
	}

	public function reverse(args:List<Dynamic>):Dynamic {
		throw new Exception("Function.reverse is abstract.");
	}

}