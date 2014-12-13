package metahub.imperative.types ;
import metahub.generate.Tie;

/**
 * @author Christopher W. Johnson
 */

typedef Expression = {
	type:Expression_Type,
	?value:Dynamic,
	?child:Expression,
	?name:String,
	?args:Array<Dynamic>,
	?path:Array<Dynamic>,
	?tie:Tie,
	?is_platform_specific:Bool
}