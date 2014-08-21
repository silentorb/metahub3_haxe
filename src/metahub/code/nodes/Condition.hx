package metahub.code.nodes;
import metahub.code.functions.Comparison;
import metahub.engine.Context;
import metahub.engine.INode;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Condition implements INode
{
	var ports = new Array<General_Port>();
	var comparison:Comparison;
	
	public function new(comparison:Comparison) 
	{
		this.comparison = comparison;
		
		for (i in 0...3) {
			ports.push(new General_Port(this, i));
		}
	}
	
	public function get_port(index:Int):General_Port {
		return ports[index];
	}

  public function get_value(index:Int, context:Context):Dynamic {
		var first = ports[1].get_external_value(context);
		var second = ports[2].get_external_value(context);
		return comparison.compare(first, second);
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception("Not implemented.");
	}

}