package metahub.meta;
import metahub.logic.schema.Rail;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Scope {
	public var rail:Rail;
	public var parent:Scope;
	public var variables = new Map<String, metahub.imperative.types.Signature>();

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