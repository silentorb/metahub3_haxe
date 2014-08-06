package metahub.code.functions;
import metahub.code.Type_Signature;
import metahub.Hub;
import metahub.schema.Kind;
import metahub.schema.Trellis;

import metahub.code.functions.Add_Int;
import metahub.code.functions.Subtract_Int;
import metahub.code.functions.Greater_Than_Int;
import metahub.code.functions.Lesser_Than_Int;

import metahub.code.functions.Float_Functions;

import metahub.code.functions.Count;


/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Library {
	var function_classes = new Map < Functions, Array<Function_Class_Info>> ();
	var hub:Hub;
	//var operator_classes = new Map <Functions, Array<Function_Class_Info>> ();

	public function new(hub:Hub) {
		this.hub = hub;

		var type_int = new Type_Signature(Kind.int);
		var type_float = new Type_Signature(Kind.float);
		var type_bool = new Type_Signature(Kind.bool);
		var type_list = new Type_Signature(Kind.list);

		add(Functions.add, "Add_Int", [ type_int, type_int, type_int ]);
		add(Functions.subtract, "Subtract_Int", [ type_int, type_int, type_int ]);
		add(Functions.greater_than, "Greater_Than_Int", [ type_bool, type_int, type_int ]);
		add(Functions.lesser_than, "Lesser_Than_Int", [ type_bool, type_int, type_int ]);
		add(Functions.count, "Count", [ type_int, type_list ]);

		var float1 = hub.schema.get_trellis("float1", hub.metahub_namespace);
		var float2 = hub.schema.get_trellis("float2", hub.metahub_namespace);
		add2(Functions.add, "Float_Functions", float2);
		add2(Functions.subtract, "Float_Functions", float2);
		add2(Functions.lesser_than, "Float_Functions", float1);
		add2(Functions.lesser_than_or_equal_to, "Float_Functions", float1);
		add2(Functions.greater_than, "Float_Functions", float1);
		add2(Functions.greater_than_or_equal_to, "Float_Functions", float1);
	}

	function add(func:metahub.code.functions.Functions, class_name:String, signature:Array<Type_Signature>) {
		if (!function_classes.exists(func)) {
			function_classes[func] = new Array<Function_Class_Info>();
		}

		function_classes[func].push(create_class_info(class_name, signature, null));
	}

	function add2(func:metahub.code.functions.Functions, class_name:String, trellis:Trellis) {
		if (!function_classes.exists(func)) {
			function_classes[func] = new Array<Function_Class_Info>();
		}

		var signature = Type_Signature.array_from_trellis(trellis);
		function_classes[func].push(create_class_info(class_name, signature, trellis));
	}

	//function add_operator(func:metahub.code.functions.Functions, class_name:String, signature:Array<Type_Signature>) {
		//if (!operator_classes.exists(func)) {
			//operator_classes[func] = new Array<Function_Class_Info>();
		//}
//
		//operator_classes[func] = create_class_info(class_name, signature);
	//}

	function create_class_info(class_name:String, signature:Array<Type_Signature>, trellis:Trellis):Function_Class_Info {
		var full_class_name = "metahub.code.functions." + class_name;
		var type = Type.resolveClass(full_class_name);
		if (type == null)
			throw new Exception("Could not find function class: " + full_class_name + ".");

		return {
			signature: signature,
			type: type,
			trellis: trellis != null ? trellis : hub.schema.get_trellis(class_name, hub.metahub_namespace, true)
		}
	}

	static function arrays_match(first:Array <Type_Signature>, second:Array <Type_Signature> ) {
		if (first.length != second.length)
			return false;

		for (i in 0...first.length) {
			if (!first[i].equals(second[i]))
				return false;
		}

		return true;
	}

	public function get_function_options(func:Functions):Array<Function_Class_Info> {
		if (!function_classes.exists(func))
			throw new Exception("Function " + func + " is not yet implemented.");

		return function_classes[func];
	}

	public function get_function_info(func:Functions, signature:Array<Type_Signature>):Function_Class_Info {
		var options = get_function_options(func);
		for (o in options) {
			if (arrays_match(o.signature, signature))
				return o;
		}

		throw new Exception("There is no implementation of " + func + " that supports those argument types.");
	}

}