package metahub.meta.types;
import metahub.meta.Scope;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Lambda extends Expression
{
	public var parameters:Array<Parameter>;
	public var expressions:Array<Expression>;
	public var scope:Scope;

	public function new(scope:Scope, parameters:Array<Parameter>, expressions:Array<Expression>) 
	{
		super(Expression_Type.lambda);
		this.scope = scope;
		this.parameters = parameters;
		this.expressions = expressions;		
	}
	
}