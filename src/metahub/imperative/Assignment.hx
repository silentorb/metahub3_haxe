package metahub.imperative;
import metahub.generate.Car;

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