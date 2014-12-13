package metahub.meta.types;
import metahub.meta.Scope;

/**
 * @author Christopher W. Johnson
 */

class Scope_Expression extends Block
{
	public var scope:Scope;
	
	public function new(scope:Scope, expressions) {
		super(expressions);
		this.type = Expression_Type.scope;
		this.scope = scope;
	}
}