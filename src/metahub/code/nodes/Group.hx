package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Group implements INode extends Standard_Node {
	public var nodes = new Array<INode>();
	public var is_back_referencing:Bool;

	public function new(is_back_referencing = false) {
		super();
		this.is_back_referencing = is_back_referencing;
		add_ports(2);
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		//if (is_back_referencing) {
			//trace('group ' + id);
			//return ports[1].get_external_value(context);
		//}

		return null;
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	override public function to_string():String {
		return "group";
	}

}