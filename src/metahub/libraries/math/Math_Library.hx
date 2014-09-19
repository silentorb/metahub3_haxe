package metahub.libraries.math;
import metahub.code.functions.Function;
import metahub.code.functions.Function_Library;
import metahub.code.nodes.Group;
import metahub.Hub;
import metahub.schema.Namespace;
import metahub.schema.Kind;
import metahub.code.Type_Signature;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Math_Library implements Function_Library
{
	public var name:String;
	public var function_map = new Map<String, Int>();
	public var signatures = new Map <Int, Array < Array < Type_Signature >>> ();
	var hub:Hub;

	public function new()
	{
		name = "Math";
	}

	public function load(hub:Hub) {
		this.hub = hub;
		var type_float = new Type_Signature(Kind.float);

		function_map['random'] = 0;
		signatures[0] = [
			[ type_float ]
		];
	}

	public function exists(function_string:String):Bool {
		return function_map.exists(function_string);
	}

	public function get_function_id(function_string:String):Int {
		return function_map[function_string];
	}

	public function create_node(func:Int, signature:Array < Type_Signature >, group:Group, is_constraint:Bool):Function {
		return new Math_Functions(hub, func, signature, group, is_constraint);
	}

	public function get_function_options(func:Int):Array<Array < Type_Signature >> {
		if (!signatures.exists(cast func))
			throw new Exception("Function " + func + " is not yet implemented.");

		return signatures[cast func];
	}

}