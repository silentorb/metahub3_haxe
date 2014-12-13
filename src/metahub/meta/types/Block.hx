package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Block extends Expression{
	public var statements = new Array<Dynamic>();

	public function new(statements:Array<Dynamic> = null) {
		if (statements != null)
			this.statements = statements;

		this.type = Expression_Type.block;
	}
}