package metahub.libraries.math;
import metahub.Hub;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Math_Library
{
	public var name:String;

	public function new() 
	{
		name = "Math";
	}
	
	public function load(hub:Hub) {
		var namespace = new Namespace();		
		hub.metahub_namespace.children[name] = namespace;
		
		namespace.functions['random'] = Functions.random;
	}
	
}