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
		var path:Path = cast expression;
		var i = path.children.length;
		while (--i >= 0) {
			if (path.children[i].type == Expression_Type.property) {
				var property_expression:metahub.imperative.types.Property_Expression = cast path.children[i];
				if (property_expression.tie.rail.trellis.is_value)
					continue;
					
				return property_expression.tie;			
			}
		}
		
		throw new Exception("Could not find property inside expression path.");
	}
	
	public static function get_path(expression:Expression):Array<Tie> {
		switch (expression.type) {
			
			case Expression_Type.path:
				return simplify_property_path(cast expression);
				
			case Expression_Type.property:
				var property_expression:Property_Expression = cast expression;
				return [ cast property_expression.tie ];
				
			case Expression_Type.function_call:
				var function_call:Function_Call = cast expression;
				if (function_call.input == null)
					throw new Exception("Not supported.");
					
				return get_path(function_call.input);
				
			default:
				return [];
				//throw new Exception("Unsupported path expression type: " + expression.type);
		}
	}
		
	static function simplify_property_path(path:Path) {
		var result = new Array<Tie>();
		for (token in path.children) {
			result = result.concat(get_path(token));
		}
		
		return result;
	}
	
	public static function reverse_path(path:Array<Tie>):Array<Tie> {		
		var result = path.map(function(t) {
			return t.other_tie;
		});
		result.reverse();
		return result;
	}

}