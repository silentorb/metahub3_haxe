package metahub.engine;

import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Relationship2
{
	public var dependent:IPort;
	public var dependency:IPort;
	public var operator:Constraint_Operator;

	public function new(dependent:IPort, operator:Constraint_Operator, dependency:IPort)
	{
		this.dependent = dependent;
		this.operator = operator;
		this.dependency = dependency;
	}

	public function set_value(value:Dynamic, context:Context = null):Dynamic {
		return dependency.set_value(value, context);
	}

	public function check_value(value:Dynamic, context:Context):Dynamic {
		var other_value = dependency.get_value(context);
		if (operator == Constraint_Operator.equals)
			return other_value;

		switch(dependency.get_type()) {
			case Kind.int:
				var first:Int = cast value;
				var second:Int = cast other_value;
				return numeric_operation(first, operator, second);

			case Kind.float:
				var first:Float = cast value;
				var second:Float = cast other_value;
				return numeric_operation(first, operator, second);

			default:
				throw new Exception("Operator " + operator + " can only be used with numeric types.");
		}

	}

	static function numeric_operation<T:(Float)>(first:T, operator:Constraint_Operator, second:T):T {
		switch (operator)
		{
			case Constraint_Operator.lesser_than:
				return first < second
				? first
				: second;

			case Constraint_Operator.greater_than:
				return first > second
				? first
				: second;

			case Constraint_Operator.lesser_than_or_equal_to:
				return first <= second
				? first
				: second;

			case Constraint_Operator.greater_than_or_equal_to:
				return first >= second
				? first
				: second;

			default:
				throw new Exception("Operator " + operator + " is not yet supported.");
		}
	}
}