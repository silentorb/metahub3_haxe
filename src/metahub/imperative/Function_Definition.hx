package metahub.imperative;

/**
 * @author Christopher W. Johnson
 */

typedef Function_Definition = {
	type:String,
	return_type:Signature,
	name:String,
	parameters:Array<Parameter>,
	block:Array<Statement>
}