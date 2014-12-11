package metahub.imperative;
import metahub.generate.Car;

/**
 * @author Christopher W. Johnson
 */

typedef Expression = {
	type:Expression_Type,
	?value:Dynamic,
	?child:Expression,
	?name:String,
	?args:Array<Dynamic>,
	?path:Array<Dynamic>
}