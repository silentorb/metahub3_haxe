package metahub.code.nodes;
import metahub.engine.Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Resolution implements IResolution {
	public var context:Context;
	public var node:INode;

	public function new(context:Context, node:INode) {
		this.context = context;
		this.node = node;
	}

	public function run(value:Dynamic) {
		node.set_value(0, value, context);
	}
}