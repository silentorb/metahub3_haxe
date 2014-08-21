package metahub.code.nodes;
import metahub.code.functions.Comparison;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition_Group implements INode
{
	var ports = new Array<General_Port>();
	var join:Condition_Join;
	
	public function new(join:Condition_Join) 
	{
		this.join = join;
		
		for (i in 0...2) {
			ports.push(new General_Port(this, i));
		}
	}
	
	public function get_port(index:Int):General_Port {
		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic {
		if (join == Condition_Join.or) {
			return get_or(context);
		}
		else {
			return get_and(context);
		}
	}
	
	function get_and(context:Context):Bool {
		for (other in ports[1].connections) 
		{
			var value:Bool = other.get_node_value(context);
			if (!value)
				return false;
		}
		
		return true;
	}

	function get_or(context:Context):Bool {
		for (other in ports[1].connections) 
		{
			var value:Bool = other.get_node_value(context);
			if (value)
				return true;
		}
		
		return false;
	}
	
  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
	}
}