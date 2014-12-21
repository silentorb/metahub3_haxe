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
	public var path:Array<Tie>;
	
	public function new(min:Float, max:Float, path:Array<Tie>) 
	{
		this.min = min;
		this.max = max;
		this.path = path;
	}
	
}