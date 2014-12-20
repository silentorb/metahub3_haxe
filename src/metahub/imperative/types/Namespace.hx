package metahub.imperative.types ;
import metahub.logic.schema.Region;

/**
 * @author Christopher W. Johnson
 */

class Namespace extends Expression {
	public var region:Region;
	public var expressions:Array<Expression>;
	
	public function new(region:Region, block:Array<Expression>) 
	{
		super(Expression_Type.namespace);
		this.region = region;
		this.expressions = block;
	}
}