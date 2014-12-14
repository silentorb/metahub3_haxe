package metahub.imperative.code;
import metahub.imperative.schema.Tie;
import metahub.imperative.types.Path;
import metahub.imperative.types.Expression;
import metahub.imperative.types.Expression_Type;

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

}