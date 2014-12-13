package metahub.libraries.math;
import metahub.code.functions.Function;
import metahub.engine.Context;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Math_Functions extends Function
{

	override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	override private function forward(args:Array<Dynamic>):Dynamic {

		switch (func) {
			case 0:
				return Math.random() * 600;
		}

		throw new Exception("No Math Function with id " + func + ".");
	}

}