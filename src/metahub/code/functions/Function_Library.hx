package metahub.code.functions;
import metahub.Hub;
import metahub.schema.Kind;

import metahub.code.functions.Add_Int;
import metahub.code.functions.Subtract_Int;
import metahub.code.functions.Greater_Than_Int;
import metahub.code.functions.Lesser_Than_Int;
import metahub.code.functions.Count;

typedef Function_Map = {
	signature:Array<Type_Signature>,
	class_name:String
}

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Library{
	var function_classes = new Map <Functions, Array<Function_Map>> ();

	public function new(hub:Hub) {

		var add = function(func:Functions, class_name:String, first:Kind = Kind.any, second:Kind = Kind.unknown) {
			if (second == Kind.unknown)
				second = first;

			var full_class_name = "metahub.code.functions." + class_name;
			var type = Type.resolveClass(full_class_name);
			if (type == null)
				throw new Exception("Could not find function class: " + full_class_name + ".");

			if (!function_classes.exists(func)) {
				function_classes[func] = new Array<Function_Map>();
			}

			//var map = function_classes[func];
			//map[kind] = type;

			var first_integer:Int = cast first;
			var second_integer:Int = cast second;
			var trellis = hub.schema.get_trellis(class_name, hub.metahub_namespace, true);

			if (!function_classes[func].exists(first_integer)) {
				function_classes[func][first_integer] = new Map<Int, Function_Info>();
			}

			function_classes[func][first_integer][second_integer] = {
				type: type,
				trellis: trellis
			};
		}
		add(Functions.add, "Add_Int");
		add(Functions.subtract, "Subtract_Int");
		add(Functions.greater_than, "Greater_Than_Int");
		add(Functions.lesser_than, "Lesser_Than_Int");
		add(Functions.count, "Count");

		//var map = {
			//: [ ],
			//Functions.subtract: [ ],
//
			//Functions.equals: [ ],
			//Functions.lesser_than: [ ],
			//Functions.greater_than: [ ],
			//Functions.lesser_than_or_equal_to: [ ],
			//Functions.greater_than_or_equal_to: [ ]
		//}

	}

	public function get_function_class(func:Functions, signature:Array<Type_Signature>):Function_Info {
		if (!function_classes.exists(func))
			throw new Exception("Function " + func + " is not yet implemented.");

		var first_integer:Int = cast first;
		var second_integer:Int = cast second;

		var map = function_classes[func];

		if (map.exists(first_integer)) {
			if (map[first_integer].exists(second_integer))
				return map[first_integer][second_integer];
		}

		if (first_integer != second_integer) {
			if (map.exists(second_integer)) {
				if (map[second_integer].exists(first_integer))
					return map[second_integer][first_integer];
			}
		}

		throw new Exception("There is no implementation of " + func + " that supports those argument types.");
	}

}