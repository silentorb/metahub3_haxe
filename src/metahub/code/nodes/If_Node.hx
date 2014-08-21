package metahub.code.nodes;
import metahub.engine.INode;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class If_Node implements INode
{
	var ports = new Array<General_Port>();

	public function new() 
	{
		for (i in 0...3) {
			ports.push(new General_Port(this, i));
		}
	}
		
	public function get_port(index:Int):General_Port {
		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic {
		var condition_result:Bool = ports[1].get_external_value(context);
		if (condition_result)
			return ports[2].get_external_value(context);
			
		return null;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
	}
}