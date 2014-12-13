package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

typedef Flow_Control = {
	type:Expression_Type,
	name:String,
	condition:Condition,
	statements:Array<Dynamic>,
}