package metahub.meta;
import metahub.logic.schema.IRail;
import metahub.logic.schema.ITie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Dynamic_Tie implements ITie
{
	public var name:String;
	public var rail:IRail;

	public function new(name:String, rail:IRail) 
	{
		this.rail = rail;
		this.name = name;
	}
	
	public function get_abstract_rail():IRail {
		return rail;
	}
	
	public function fullname():String {
		return "Dynamic." + name;
	}
}