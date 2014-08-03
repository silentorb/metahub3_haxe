package metahub.code;
import metahub.code.Type_Signature;
import metahub.code.functions.Function_Class_Info;
import metahub.code.functions.Functions;
import metahub.Hub;
import metahub.schema.Kind;

import metahub.code.functions.Add_Int;
import metahub.code.functions.Subtract_Int;
import metahub.code.functions.Greater_Than_Int;
import metahub.code.functions.Lesser_Than_Int;
import metahub.code.functions.Count;


/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Library{
	var function_classes = new Map <Functions, Array<Function_Class_Info>> ();
	var operator_classes = new Map <Functions, Array<Function_Class_Info>> ();

	public function new(hub:Hub) {
		
		var type_int = new Type_Signature(Kind.int);
		var type_float = new Type_Signature(Kind.float);
		var type_bool = new Type_Signature(Kind.bool);
		var type_list = new Type_Signature(Kind.list);
		
		add(Functions.add, "Add_Int", [ type_int, type_int, type_int ]);
		add(Functions.subtract, "Subtract_Int", [ type_int, type_int, type_int ]);
		add(Functions.greater_than, "Greater_Than_Int", [ type_bool, type_int, type_int ]);
		add(Functions.lesser_than, "Lesser_Than_Int", [ type_bool, type_int, type_int ]);
		add(Functions.count, "Count", [ type_int, type_list ]);
	}
	
	function add(func:metahub.code.functions.Functions, class_name:String, signature:Array<Type_Signature>) {
		if (!function_classes.exists(func)) {
			function_classes[func] = new Array<Function_Class_Info>();
		}

		function_classes[func] = create_class_info(class_name, signature);
	}
	
	function add_operator(func:metahub.code.functions.Functions, class_name:String, signature:Array<Type_Signature>) {
		if (!operator_classes.exists(func)) {
			operator_classes[func] = new Array<Function_Class_Info>();
		}

		operator_classes[func] = create_class_info(class_name, signature);
	}
	
	function create_class_info(class_name:String, signature:Array<Type_Signature>) {
		var full_class_name = "metahub.code.functions." + class_name;
		var type = Type.resolveClass(full_class_name);
		if (type == null)
			throw new Exception("Could not find function class: " + full_class_name + ".");

		//var trellis = hub.schema.get_trellis(class_name, hub.metahub_namespace, true);
		return {
			signature: signature,
			type: type
		}
	}
	
	public function get_function_info(func:Functions, signature:Array<Type_Signature>):Function_Class_Info {
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