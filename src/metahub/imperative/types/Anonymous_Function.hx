package metahub.imperative.types;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Anonymous_Function extends Expression
{
	public var parameters:Array<Parameter>;
	public var expressions:Array<Expression>;
	public var return_type:Signature;
	
	public function new(parameters:Array<Parameter>,expressions:Array<Expression>, return_type:Signature = null) 
	{
		super(Expression_Type.function_definition);
		this.parameters = parameters;
		this.expressions = expressions;
		this.return_type = return_type == null
		? { type: Kind.none }
		: return_type;
	}
	
}