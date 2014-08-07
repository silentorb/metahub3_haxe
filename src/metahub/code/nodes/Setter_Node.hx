package metahub.code.nodes;
import metahub.code.Setter;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Setter_Node implements INode {

	var port:General_Port;
	var setter:Setter;
	var scope:Scope;

	public function new(setter:Setter, scope:Scope) {
		port = new General_Port(this, 0);
		this.setter = setter;
		this.scope = scope;
	}

	public function get_port(index:Int):General_Port {
		return port;
	}

  public function get_value(index:Int, context:Context):Dynamic{
		throw new Exception("Not implemented.");
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		setter.run(context.node, scope);
	}

}