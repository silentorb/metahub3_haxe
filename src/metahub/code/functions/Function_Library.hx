package metahub.code.functions;
import metahub.Hub;
import metahub.schema.Kind;

import metahub.code.functions.Add_Int;
import metahub.code.functions.Greater_Than_Int;
import metahub.code.functions.Lesser_Than_Int;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Library{
	public var function_classes = new Map < Functions, Map < Int, Function_Info >> ();

	public function new(hub:Hub) {

		var add = function(func:Functions, class_name:String, kind:Kind = Kind.any) {
			var full_class_name = "metahub.code.functions." + class_name;
			var type = Type.resolveClass(full_class_name);
			if (type == null)
				throw new Exception("Could not find function class: " + full_class_name + ".");

			if (!function_classes.exists(func)) {
				function_classes[func] = new Map<Int, Function_Info>();
			}

			//var map = function_classes[func];
			//map[kind] = type;

			var integer:Int = cast kind;
			var trellis = hub.schema.get_trellis(class_name, hub.metahub_namespace, true);

			function_classes[func][integer] = {
				type: type,
				trellis: trellis
			};
		}
		add(Functions.add, "Add_Int");
		add(Functions.greater_than, "Greater_Than_Int");
		add(Functions.lesser_than, "Lesser_Than_Int");

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

	public function get_function_class(func:Functions, kind:Kind):Function_Info {
		if (!function_classes.exists(func))
			throw new Exception("Function " + func + " is not yet implemented.");

		var map = function_classes[func];
		var type:Int = cast kind;
		if (map.exists(type))
			return map[type];

		type = cast Kind.any;
		if (!map.exists(type))
			throw new Exception("Function " + func + " is not yet implemented.");

		if (map[type] == null)
			throw new Exception("Function " + func + " is not yet implemented.");

		return map[type];
	}

}