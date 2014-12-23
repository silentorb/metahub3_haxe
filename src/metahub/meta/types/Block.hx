package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Block extends Expression{
	public var children = new Array<Dynamic>();

	public function new(statements:Array<Dynamic> = null) {
		if (statements != null)
			this.children = statements;

		super(Expression_Type.block);
	}
}