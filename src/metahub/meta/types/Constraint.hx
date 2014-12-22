package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Constraint extends Expression
{
	public var first:Expression;
	public var second:Expression;
	public var operator:String;
	public var lambda:Lambda;
	
	public function new(first, second, operator = "=", lambda:Lambda = null) {
		this.type = Expression_Type.constraint;
		this.first = first;
		this.second = second;
		this.operator = operator;
		this.lambda = lambda;
	}
}