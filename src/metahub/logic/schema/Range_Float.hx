package metahub.logic.schema;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Range_Float implements IRange
{
	public var min:Float;
	public var max:Float;
  public var type:Int;
	
	public function new(min:Float, max:Float) 
	{
		this.min = min;
		this.max = max;
	}
	
}