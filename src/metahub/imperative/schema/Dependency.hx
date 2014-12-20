package metahub.imperative.schema ;
import metahub.logic.schema.Rail;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Dependency
{
	public var rail:Rail;
	public var allow_ambient = true;

	public function new(rail:Rail) 
	{
		this.rail = rail;
	}
	
}