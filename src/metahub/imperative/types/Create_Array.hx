package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Create_Array extends Expression
{
	public var children:Array<Expression>;
	
	public function new(children:Array<Expression>) {
		super(Expression_Type.create_array);
		this.children = children;
	}	
}