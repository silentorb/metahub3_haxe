package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Constraint extends Expression
{
	public var first:Expression;
	public var second:Expression;
	public var operator:String;
	
	public function new(first, second, operator = "=") {
		this.type = Expression_Type.constraint;
		this.first = first;
		this.second = second;
		this.operator = operator;
	}
}