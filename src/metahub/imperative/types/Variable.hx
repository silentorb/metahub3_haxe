package metahub.imperative.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Variable extends Expression {
	public var name:String;

	public function new(name:String, child:Expression = null) 
	{
		super(Expression_Type.variable);
		this.name = name;
		this.child = child;
	}
	
}