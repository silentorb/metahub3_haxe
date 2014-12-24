package metahub.meta.types;
import metahub.logic.schema.Signature;

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
	
	override public function get_signature():Signature 
	{
		if (children.length == 0)
			throw new Exception("Cannot find signature of empty array.");
		
		return children[children.length - 1].get_signature();
	}
}