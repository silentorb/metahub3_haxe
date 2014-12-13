package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Scope_Expression extends Expression
{
	public function new() {
		this.type = Expression_Type.scope;
	}
}