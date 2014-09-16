package metahub.engine;
import metahub.code.nodes.INode;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Change
{
	public var node:INode;
	var index:Int;
	var value:Dynamic;
	var context:Context;
	var source:General_Port;

	public function new(node:INode, index:Int, value:Dynamic, context:Context, source:General_Port = null)
	{
		if (value == null)
			throw new Exception("Not yet supported.");

		this.node = node;
		this.index = index;
		this.value = value;
		this.context = context;
		this.source = source;
	}

	public function run() {
		node.set_value(index, value, context, source);
	}

}