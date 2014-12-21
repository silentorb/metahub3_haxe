package metahub.meta.types;
import metahub.logic.schema.ITie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Property_Expression extends Expression {
	public var tie:ITie;
	
	public function new(tie:ITie) 
	{
		type = Expression_Type.property;
		this.tie = tie;		
	}
	
}