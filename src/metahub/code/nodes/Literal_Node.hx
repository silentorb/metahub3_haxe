package metahub.code.nodes ;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Literal_Node implements INode
{
	public var value:Dynamic;
	public var output:General_Port;
	public var group:Group;

	public function new(value:Dynamic, group:Group)
	{
		this.value = value;
		this.group = group;
		output = new General_Port(this, 0);
	}

	public function get_port(index:Int):General_Port {
		return output;
	}

	public function get_port_count():Int {
		return 1;
	}

  public function get_value(index:Int, context:Context):Dynamic {
		return value;
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	public function to_string():String {
		return 'literal "' + value + '"';
	}

}