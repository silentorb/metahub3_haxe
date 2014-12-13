package metahub.imperative;
import metahub.imperative.schema.Railway;

/**
 * ...
 * @author Christopher W. Johnson
 */
@:expose class Imp
{
	public var railway:Railway;
	
	public function new(hub:Hub, target_name:String) 
	{
		railway = new Railway(hub, target_name);
	}
	
	public function translate(root:metahub.meta.types.Expression) {
		railway.process(root, null);
		railway.generate_code();
	}
}