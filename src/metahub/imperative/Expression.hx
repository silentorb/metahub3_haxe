package metahub.imperative;
import metahub.generate.Car;

/**
 * @author Christopher W. Johnson
 */

typedef Expression = {
	type:String,
	?value:Dynamic,
	?path:Array<Car>
}