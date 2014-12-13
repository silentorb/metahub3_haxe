package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Parent_Class extends Expression
{
	public function new(child:Expression) 
	{
		super(Expression_Type.parent_class);
		this.child = child;
	}
	
}