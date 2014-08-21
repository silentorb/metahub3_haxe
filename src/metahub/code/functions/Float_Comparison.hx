package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Float_Comparison implements Comparison
{

	var type:Functions;
	
	public function new(type:Functions) 
	{
		this.type = type;
	}
	
	public function compare(f:Dynamic, s:Dynamic):Bool {
		var first:Float = f;
		var second:Float = s;
		
		switch(type) {
			case Functions.equals: return first == second;
		}
	}
	
	
}