package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

class Assignment extends Expression {
	public var operator:String;
	public var target:Expression;
	public var expression:Expression;
	
	public function new(target:Expression, operator:String, expression:Expression) {
		super(Expression_Type.assignment);
		this.operator = operator;
		this.target = target;
		this.expression = expression;
	}
}
//typedef Assignment =
//{
	//type:String,
	//operator:String,
	//target:Expression,
	//expression:Expression
//}