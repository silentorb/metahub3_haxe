package metahub.engine;
import metahub.code.nodes.Group;
import metahub.engine.Node.Identity;

/**
 * @author Christopher W. Johnson
 */

interface INode {
	function get_port_count():Int;
	function get_port(index:Int):General_Port;
  function get_value(index:Int, context:Context):Dynamic;
  function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null):Void;
	function to_string():String;
	var group:Group;
}