package metahub.imperative;

/**
 * @author Christopher W. Johnson
 */

typedef Function_Call = {
		type:String,
		name:String,
		caller:String,
		args:Array<Dynamic>,
		is_platform_specific:Bool
}