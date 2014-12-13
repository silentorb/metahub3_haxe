package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Literal extends Expression {
	public var value:Dynamic;

	public function new(value:Dynamic)
	{
		super(Expression_Type.literal);
		this.value = value;
	}
	
}