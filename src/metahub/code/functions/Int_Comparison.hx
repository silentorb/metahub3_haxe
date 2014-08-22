package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Int_Comparison implements Comparison
{

	var type:Functions;

	public function new(type:Functions)
	{
		this.type = type;
	}

	public function compare(f:Dynamic, s:Dynamic):Bool {
		var first:Int = f;
		var second:Int = s;

		switch(type) {
			case Functions.equals: return first == second;
			default: throw new Exception("Could not find a valid comparison operation.");
		}
	}


}