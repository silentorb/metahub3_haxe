package metahub.engine;
import metahub.engine.Node.Identity;

/**
 * @author Christopher W. Johnson
 */

interface INode {
  public var id:Identity;

	function get_port(index:Int):IPort;
  function get_value(index:Int):Dynamic;
  function set_value(index:Int, value:Dynamic):Void;
	var port_count(get, null):Int;
}