package metahub.imperative;

/**
 * @author Christopher W. Johnson
 */

typedef Function_Definition = {
	type:String,
	return_type:Dynamic,
	name:String,
	parameters:Array<Parameter>,
	block:Array<Statement>
}