package metahub.imperative.types ;
import metahub.schema.Kind;
import metahub.generate.Rail;

/**
 * @author Christopher W. Johnson
 */

typedef Signature ={
	type:Kind,
	?rail:Rail,
	?is_value:Bool,
	?is_numeric:Int
}