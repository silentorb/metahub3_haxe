package metahub.meta.types;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Function_Scope extends Expression
{
	public var expression:Expression;
	public var lambda:Lambda;
	
	public function new(expression:Expression, lambda:Lambda) 
	{
		super(Expression_Type.function_scope);
		this.expression = expression;
		this.lambda = lambda;
	}
	
}