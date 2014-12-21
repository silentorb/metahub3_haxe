package metahub.imperative.types;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Anonymous_Function extends Expression
{
	public var parameters:Array<Parameter>;
	public var block:Array<Expression>;
	public var return_type:Signature;
	
	public function new(parameters:Array<Parameter>,block:Array<Expression>, return_type:Signature = null) 
	{
		super(Expression_Type.function_definition);
		this.parameters = parameters;
		this.block = block;
		this.return_type = return_type == null
		? { type: Kind.none }
		: return_type;
	}
	
}