package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Self extends Expression {

	public function new(child:Expression = null) 
	{
		super(Expression_Type.self);
		this.child = child;
	}
	
}