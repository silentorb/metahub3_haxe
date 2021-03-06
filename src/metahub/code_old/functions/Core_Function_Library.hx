package metahub.code.functions;
import metahub.code.nodes.Group;
import metahub.code.Type_Signature;
import metahub.Hub;
import metahub.schema.Kind;
import metahub.schema.Trellis;

import metahub.code.functions.Add_Int;
import metahub.code.functions.Subtract_Int;
import metahub.code.functions.Greater_Than_Int;
import metahub.code.functions.Lesser_Than_Int;

import metahub.code.functions.Float_Functions;
import metahub.code.functions.Struct_Functions;
import metahub.code.functions.Struct_Float_Functions;
import metahub.code.functions.List_Functions;
import metahub.code.functions.Count;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Core_Function_Library implements Function_Library {
	var function_classes = new Map < Functions, Array < Function_Class_Info >> ();
	var hub:Hub;

	public function load(hub:Hub) {
		this.hub = hub;

		// Int
		var type_int = new Type_Signature(Kind.int);
		var type_float = new Type_Signature(Kind.float);
		var type_bool = new Type_Signature(Kind.bool);
		var type_list = new Type_Signature(Kind.list);
		var type_unknown = new Type_Signature(Kind.unknown);
		var int3 = [ type_int, type_int, type_int ];
		var bool_int2 = [ type_int, type_int ];

		add(Functions.add, "Add_Int", int3);
		add(Functions.subtract, "Subtract_Int", int3);
		add(Functions.greater_than, "Greater_Than_Int", bool_int2);
		add(Functions.lesser_than, "Lesser_Than_Int", bool_int2);
		add(Functions.count, "Count", [ type_int, type_list ]);

		// Struct
		var struct_type = new Type_Signature(Kind.reference);
		struct_type.is_numeric = 1;
		var struct3 = [ struct_type, struct_type, struct_type ];

		add(Functions.add, "Struct_Functions", struct3);

		// Float
		var bool_float2 = hub.schema.get_trellis("float1", hub.metahub_namespace);
		var float3 = hub.schema.get_trellis("float2", hub.metahub_namespace);

		add2(Functions.add, "Float_Functions", float3);
		add2(Functions.subtract, "Float_Functions", float3);
		add2(Functions.multiply, "Float_Functions", float3);
		add2(Functions.divide, "Float_Functions", float3);

		add2(Functions.lesser_than, "Float_Functions", bool_float2);
		add2(Functions.lesser_than_or_equal_to, "Float_Functions", bool_float2);
		add2(Functions.greater_than, "Float_Functions", bool_float2);
		add2(Functions.greater_than_or_equal_to, "Float_Functions", bool_float2);

		var struct_float = [ struct_type, struct_type, type_float ];

		add(Functions.multiply, "Struct_Float_Functions", struct_float);

		var list_any = [ type_list, type_list, type_unknown ];
		add(Functions.add, "List_Functions", list_any);
		add(Functions.first, "List_Functions", [ type_unknown, type_list ]);
	}

	function add(func:metahub.code.functions.Functions, class_name:String, signature:Array<Type_Signature>) {
		if (!function_classes.exists(func)) {
			function_classes[func] = new Array<Function_Class_Info>();
		}

		function_classes[func].push(create_class_info(class_name, signature));
	}

	function add2(func:metahub.code.functions.Functions, class_name:String, trellis:Trellis) {
		if (!function_classes.exists(func)) {
			function_classes[func] = new Array<Function_Class_Info>();
		}

		var signature = Type_Signature.array_from_trellis(trellis);
		function_classes[func].push(create_class_info(class_name, signature));
	}

	public function exists(function_string:String):Bool {
		return Reflect.field(Functions, function_string) != null;
	}

	public function get_function_id(function_string:String):Int {
		return cast Type.createEnum(Functions, function_string);
	}

	public function create_node(func:Int, signature:Array < Type_Signature >, group:Group, is_constraint:Bool):Function {
		var info = get_function_info(func, signature);
		return Type.createInstance(info.type, [hub, func, signature, group, is_constraint]);
	}

	function create_class_info(class_name:String, signature:Array<Type_Signature>):Function_Class_Info {
		var full_class_name = "metahub.code.functions." + class_name;
		var type = Type.resolveClass(full_class_name);
		if (type == null)
			throw new Exception("Could not find function class: " + full_class_name + ".");

		return {
			signature: signature,
			type: type,
			//trellis: trellis != null ? trellis : hub.schema.get_trellis(class_name, hub.metahub_namespace)
		}
	}

	function get_function_info(func:Int, signature:Array<Type_Signature>):Function_Class_Info {
		var options = get_function_options2(func);
		for (o in options) {
			if (arrays_match(o.signature, signature))
				return o;
		}

		throw new Exception("There is no implementation of " + func + " that supports those argument types.");
	}

	public function get_function_options(func:Int):Array<Array<Type_Signature>> {
		if (!function_classes.exists(cast func))
			throw new Exception("Function " + func + " is not yet implemented.");

		return Lambda.array(Lambda.map(function_classes[cast func], function(f) { return f.signature; } ));
	}

	public function get_function_options2(func:Int):Array<Function_Class_Info> {
		if (!function_classes.exists(cast func))
			throw new Exception("Function " + func + " is not yet implemented.");

		return function_classes[cast func];
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
}