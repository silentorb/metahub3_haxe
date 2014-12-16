package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

class Condition {
	public var operator:String;
	public var expressions:Dynamic;
	
	public function new(operator:String, expressions:Dynamic) {
		this.operator = operator;
		this.expressions = expressions;
	}
}