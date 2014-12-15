package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Null extends Expression
{
	public function new() 
	{
		super(Expression_Type.null_value);
	}
	
}