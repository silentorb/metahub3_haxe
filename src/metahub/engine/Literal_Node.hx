package metahub.engine;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Literal_Node implements INode
{
	public var value:Dynamic;
	public var output:General_Port;

	public function new(value:Dynamic) 
	{
		this.value = value;
		output = new General_Port(this, 0);
	}
	
	public function get_port(index:Int):General_Port {
		return output;
	}
	
  public function get_value(index:Int, context:Context):Dynamic {
		return value;
	}
	
  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		
	}
}