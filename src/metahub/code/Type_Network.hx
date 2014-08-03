package metahub.code;
import metahub.code.expressions.Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Type_Network {

	public static function analyze(expression:Expression):Node_Signature {
		while (true) {
			var options = expression.get_types();
			if (options.length == 1) {

			}
			else {
				throw new Exception("Not implemented yet.");
			}
		}
	}

}