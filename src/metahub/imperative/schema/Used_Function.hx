package metahub.imperative.schema;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Used_Function {
	public var name:String;
	public var is_platform_specific:Bool;
	
	public function new(name:String, is_platform_specific:Bool = false) {
		this.name = name;
		this.is_platform_specific = is_platform_specific;
	}
}