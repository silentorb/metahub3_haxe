package metahub.meta.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Path extends Expression {
	public var children:Array<Expression>;
	
	public function new(children:Array<Expression>) 
	{
		super(Expression_Type.path);
		this.children = children;		
	}
	
}