package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Insert extends Expression {
	public var code:String;
	
	public function new(code:String) 
	{
		super(Expression_Type.insert);
		this.code = code;
	}
}