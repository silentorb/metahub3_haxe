package metahub.imperative.types ;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Statement extends Expression {
	public var name:String;

	public function new(name:String)
	{
		super(Expression_Type.statement);
		this.name = name;
	}
	
}
//typedef Statement = {
	//type:Expression_Type
//}