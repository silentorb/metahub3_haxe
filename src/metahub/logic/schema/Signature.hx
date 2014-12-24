package metahub.logic.schema;
import metahub.schema.Kind;
import metahub.logic.schema.Rail;

/**
 * @author Christopher W. Johnson
 */

typedef Signature = {
	type:Kind,
	?rail:Rail,
	?is_value:Bool,
	?is_numeric:Int
}