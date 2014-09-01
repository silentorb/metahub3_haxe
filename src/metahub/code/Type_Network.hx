package metahub.code;
import metahub.code.expressions.Expression;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Type_Network {
/*
	public static function analyze2(expression:Expression, scope:Scope, start_type:Type_Signature = null):Node_Signature {
		if (start_type == null)
			start_type = new Type_Signature(Kind.unknown);

		start_type = start_type.copy();
		var options = expression.get_types();
		var children = expression.children;
		while (options == null) {
			//if (children.length == 0)
				//throw new Exception("Missing expression type information.");
//
			////return new Node_Signature([]);
//
			//expression = children[0];
			//children = expression.children;
			//options = expression.get_types();
			return null;
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
			var child_result = analyze2(child, scope, result.signature[i++]);
			if (child_result != null)
				result.children.push(child_result);
		}

		return result;
	}
*/
	public static function get_match(start_type:Type_Signature, options:Array<Array<Type_Signature>>) {
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

	public static function signatures_match(first: Array < Type_Signature > , second: Array < Type_Signature > ) {
		if (first.length != second.length)
			return false;

		for (i in 0...first.length) {
			if (!first[i].equals(second[i]))
				return false;
		}

		return true;
	}
}