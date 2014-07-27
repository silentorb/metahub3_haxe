package metahub.engine;
import metahub.engine.Node.Identity;

/**
 * @author Christopher W. Johnson
 */

interface INode {
  //public var id:Identity;

	function get_port(index:Int):General_Port;	
  function get_value(index:Int, context:Context):Dynamic;
  function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null):Void;
	//var port_count(get, null):Int;
}