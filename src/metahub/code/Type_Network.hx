package metahub.code;
import metahub.code.expressions.Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Type_Network {

	public static function analyze(expression:Expression, start_type:Type_Signature, scope:Scope):Node_Signature {
		start_type = start_type.copy();
		var options = expression.get_types();
		var children = expression.children;
		if (options == null) {
			expression = children[0];
			children = expression.children;
			options = expression.get_types();
			if (options == null)
				throw new Exception("Error determining types.");
		}

		var option = get_match(start_type, options);
		if (option == null)
			throw new Exception("Type mismatch with type <" + start_type.type.to_string() + "> and expression <" + expression.to_string() + ">");

		// Eventually this might need to be mixed in with get_match and allowed to try for other matches,
		// but right now multiple options is not used much and none of them have a variable amount of parameters,
		// so this error is currently only an internal bug and worth catching separately for debuggin purposes.
		if (option.length < children.length + 1)
			throw new Exception("Invalid number of parameters in type definition.");
		
		var result = new Node_Signature(option);
			
		var i = 1;
		for (child in children) {
			var child_result = analyze(child, result.signature[i++], scope);
			result.children.push(child_result);
		}

		return result;
	}

	static function get_match(start_type:Type_Signature, options:Array<Array<Type_Signature>>) {
		for (option in options) {
			//trace("Comparing " + option[0].to_string() + " and " + start_type.to_string());
			if (option[0].equals(start_type)) {
				var result = Type_Signature.copy_array(option);
				result[0].resolve(start_type);
				start_type.resolve(result[0]);
				return result;
			}
		}

		return null;
	}
}