package metahub.generate;
import metahub.code.expressions.Function_Call;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Car
{
	public var tie:Tie = null;
	public var func:Function_Call = null;
	
	public function new(tie:Tie, func:Function_Call)
	{
		this.tie = tie;
		this.func = func;
	}
	
}