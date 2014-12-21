package metahub.meta;
import metahub.logic.schema.IRail;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Scope {
	public var rail:IRail;
	public var parent:Scope;
	public var variables = new Map<String, Dynamic>();

	public function new(parent:Scope = null) {
		this.parent = parent;
		if (parent != null)
			rail = parent.rail;
	}

	public function find(name:String) {
		if (variables.exists(name))
			return variables[name];

		if (parent != null)
			return parent.find(name);

		return null;
	}
}