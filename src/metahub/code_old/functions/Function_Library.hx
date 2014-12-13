package metahub.code.functions;
import metahub.code.nodes.Group;

/**
 * ...
 * @author Christopher W. Johnson
 */
interface Function_Library {
	function load(hub:Hub):Void;
	function exists(function_string:String):Bool;
	function get_function_id(function_string:String):Int;
	function get_function_options(func:Int):Array < Array < Type_Signature >>;
	function create_node(func:Int, signature:Array < Type_Signature >, group:Group, is_constraint:Bool):Function;
}