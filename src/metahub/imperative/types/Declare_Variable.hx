package metahub.imperative.types ;
import metahub.logic.schema.Signature;

/**
 * @author Christopher W. Johnson
 */

class Declare_Variable extends Expression {
	public var name:String;
	public var signature:Signature;
	public var expression:Expression;
	
	public function new(name:String, signature:Signature, expression:Expression) {
		super(Expression_Type.declare_variable);
		this.name = name;
		this.signature = signature;
		this.expression = expression;
	}
}
//typedef Declare_Variable =
//{
	//type:String,
	//name:String,
	//signature:Signature,
	//expression:Expression
//}