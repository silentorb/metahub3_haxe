package metahub.imperative.code;
import metahub.logic.schema.Tie;
//import metahub.imperative.types.Function_Call;
//import metahub.imperative.types.Path;
//import metahub.imperative.types.Expression;
//import metahub.imperative.types.Expression_Type;
//import metahub.imperative.types.Property_Expression;
import metahub.meta.types.*;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Parse
{

	public static function get_start_tie(expression:Expression):Tie {
		var path:Path = cast expression;
		var property_expression:metahub.imperative.types.Property_Expression = cast path.children[0];
		return property_expression.tie;
	}

	public static function get_end_tie(expression:Expression):Tie {
		var path = get_path(expression);
		var i = path.length;
		while (--i >= 0) {
			if (!path[i].rail.trellis.is_value)
				return path[i];
		}
		
		throw new Exception("Could not find property inside expression path.");
	}
	
	//public static function get_end_tie(expression:Expression):Tie {
		//var path:Path = cast expression;
		//var i = path.children.length;
		//while (--i >= 0) {
			//if (path.children[i].type == Expression_Type.property) {
				//var property_expression:metahub.imperative.types.Property_Expression = cast path.children[i];
				//if (property_expression.tie.rail.trellis.is_value)
					//continue;
//
				//return property_expression.tie;
			//}
		//}
//
		//throw new Exception("Could not find property inside expression path.");
	//}

	public static function get_path(expression:Expression):Array<Tie> {
		switch (expression.type) {

			case Expression_Type.path:
				return get_path_from_array(cast (expression, Path).children);
				
			case Expression_Type.array:
				return get_path_from_array(cast (expression, Array_Expression).children);

			case Expression_Type.property:
				var property_expression:Property_Expression = cast expression;
				return [ cast property_expression.tie ];

			case Expression_Type.function_call:
				var function_call:Function_Call = cast expression;
				return [];
				//throw new Exception("Not supported.");
				//if (function_call.input == null)
					//return null;
					//throw new Exception("Not supported.");

				//return get_path(function_call.input);

			case Expression_Type.variable:
				return null;

			default:
				return [];
				//throw new Exception("Unsupported path expression type: " + expression.type);
		}
	}
	
	public static function get_path_from_array(expressions:Array<Expression>):Array<Tie> {
		var result = new Array<Tie>();
		for (token in expressions) {
			result = result.concat(get_path(token));
		}

		return result;
	}

	public static function normalize_path(expression:Expression):Array<Expression> {
		switch (expression.type) {

			case Expression_Type.path:
				var path:Path = cast expression;
				var result = [];
				for (token in path.children) {
					result = result.concat(normalize_path(token));
				}
				return result;

			case Expression_Type.function_call:
				var function_call:Function_Call = cast expression;
				//if (function_call.input != null)
					//return normalize_path(function_call.input);

				return [ expression ];

			default:
				return [ expression ];
		}
	}


	public static function resolve(expression:Expression):Expression {
		switch (expression.type) {

			case Expression_Type.path:
				var path:Path = cast expression;
				return path.children[path.children.length - 1];

			case Expression_Type.function_call:
				throw new Exception("Not implemented.");

			default:
				return expression;
		}
	}

	//static function simplify_property_path(path:Path) {
		//var result = new Array<Tie>();
		//for (token in path.children) {
			//result = result.concat(get_path(token));
		//}
//
		//return result;
	//}

	public static function reverse_path(path:Array<Tie>):Array<Tie> {
		var result = path.map(function(t) {
			return t.other_tie;
		});
		result.reverse();
		return result;
	}

}