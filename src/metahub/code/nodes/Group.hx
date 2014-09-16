package metahub.code.nodes;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Group implements INode extends Standard_Node {
	public var is_back_referencing:Bool = false;
	public var weight:Float = 1;
	public var only_new:Bool = false; // If true, nodes in this group are only evaluated for new entities.

	public function new(parent:Group, only_new:Bool = false) {
		super(parent);
		if (parent != null && parent.is_back_referencing != null)
			is_back_referencing = parent.is_back_referencing;

		add_ports(2);
		this.only_new = only_new;
	}

  override public function get_value(index:Int, context:Context):Dynamic {
		return null;
	}

  override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	override public function to_string():String {
		return "group";
	}

}