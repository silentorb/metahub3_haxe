package metahub.imperative.types ;
import metahub.imperative.schema.Rail;

/**
 * @author Christopher W. Johnson
 */

class Class_Definition extends Expression {
	public var rail:Rail;
	public var expressions:Array<Expression>;
	
	public function new(rail:Rail, statements:Array<Expression>) 
	{
		super(Expression_Type.class_definition);
		this.rail = rail;
		this.expressions = statements;
	}
}