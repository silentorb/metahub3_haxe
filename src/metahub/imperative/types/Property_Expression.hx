package metahub.imperative.types;
import metahub.imperative.schema.Tie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Property_Expression extends Expression
{
	public var tie:Tie;
	
	public function new(tie:Tie, child:Expression = null) 
	{
		super(Expression_Type.property);
		this.tie = tie;
		this.child = child;
	}
	
}