package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Array_Expression extends Expression{
	public var children:Array<Expression>;

	public function new(children:Array<Expression> = null) {
		this.children = children != null
		 ? children : [];
		
		super(Expression_Type.array);
	}
}