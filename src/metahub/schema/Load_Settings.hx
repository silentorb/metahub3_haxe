package metahub.schema;

/**
 * @author Christopher W. Johnson
 */

class Load_Settings {
	public var namespace:Namespace;
	public var auto_identity:Bool;
	
	public function new(namespace:Namespace, auto_identity:Bool = false) {
		this.namespace = namespace;
		this.auto_identity = auto_identity;
	}
}