package metahub.meta;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Scope {
	public var trellis:Trellis;
	public var parent:Scope;
	public var variables = new Map<String, Dynamic>();

	public function new(parent:Scope = null) {
		this.parent = parent;
	}

	public function find(name:String) {
		if (variables.exists(name))
			return variables[name];

		if (parent != null)
			return parent.find(name);

		return null;
	}
}