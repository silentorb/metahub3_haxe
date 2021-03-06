package metahub.meta.types;
import metahub.logic.schema.Signature;
import metahub.logic.schema.Tie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Property_Expression extends Expression {
	public var tie:Tie;
	
	public function new(tie:Tie) 
	{
		super(Expression_Type.property);
		this.tie = tie;		
	}
	
	override public function get_signature():Signature 
	{
		return tie.get_signature();
	}
	
}