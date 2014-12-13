package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

typedef Assignment =
{
	type:String,
	operator:String,
	target:Expression,
	expression:Expression
}