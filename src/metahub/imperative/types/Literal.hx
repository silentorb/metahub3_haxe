package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Literal extends Expression {
	public var value:Dynamic;
	public var signature:Signature;

	public function new(value:Dynamic, signature:Signature)
	{
		super(Expression_Type.literal);
		this.value = value;
		this.signature = signature;
	}
	
}