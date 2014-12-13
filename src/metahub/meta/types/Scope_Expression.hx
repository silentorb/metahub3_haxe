package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Scope_Expression extends Block
{
	public function new() {
		super([]);
		this.type = Expression_Type.scope;
	}
}