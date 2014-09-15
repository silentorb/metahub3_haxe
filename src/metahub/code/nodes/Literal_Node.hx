package metahub.code.nodes ;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Literal_Node extends Standard_Node
{
	public var value:Dynamic;

	public function new(value:Dynamic, group:Group)
	{
		super(group);
		this.value = value;
		add_ports(1);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		return value;
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		if (value != this.value)
			context.hub.add_change(source.node, source.id, this.value, context, source);
	}

	override public function to_string():String {
		return 'literal "' + value + '"';
	}

}