package metahub.meta;
import metahub.logic.schema.IRail;
import metahub.logic.schema.ITie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Dynamic_Rail implements IRail
{
	var properties = new Map<String, ITie>();
	
	public function new() 
	{
		
	}
	
	public function get_tie_or_null(name:String):ITie {
		if (!properties.exists(name)) {
			properties[name] = new Dynamic_Tie(name, this);
		}
		
		return properties[name];
	}
	
	public function get_tie_or_error(name:String):ITie {
		return get_tie_or_null(name);
	}
}