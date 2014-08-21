package metahub.code.nodes;
import metahub.engine.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition implements INode
{
	var ports = new Array<General_Port>();

	public function new() 
	{
		
	}
	
	public function get_port(index:Int):General_Port {
		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic {

		return null;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
	}

}