package metahub.meta.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Variable extends Expression
{
	public var name:String;
	
	public function new(name:String) {
		super(Expression_Type.variable);
		this.name = name;
	}
	
}