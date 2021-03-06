package metahub.code.nodes;
import metahub.code.Scope;
import metahub.code.expressions.Block;
import metahub.code.expressions.Expression;
import metahub.code.Type_Signature;
import metahub.debug.Entry;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.code.nodes.INode;
import metahub.engine.Node_Context;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Block_Node implements INode extends Standard_Node {
	var scope:Scope;

	public function new(scope:Scope, group:Group) {
		super(group);
		for (i in 0...3) {
			ports.push(new General_Port(this, i));
		}
		this.scope = scope;

	}

  override public function get_value(index:Int, context:Context):Change {
		#if trace
			context.hub.history.add(new Entry('Block'));
			context.hub.history.start_anchor();
		#end

		var definition = scope.definition;
		if (definition.trellis == null || definition.is_particular_node) {
			resolve_block(context);
		}
		else {
			var nodes = scope.hub.get_nodes_by_trellis(definition.trellis);
			for (node in nodes) {
				var node_context = new Node_Context(node, scope.hub);
				resolve_block(node_context);
				#if trace
					context.hub.history.back_to_anchor();
				#end
			}
		}

		#if trace
			context.hub.history.end_anchor();
		#end

		return null;
	}

  override public function set_value(index:Int, change:Change, context:Context, source:General_Port = null) {
		//throw new Exception("Not implemented.");
	}

	public function run() {
		var nodes = scope.hub.get_nodes_by_trellis(scope.definition.trellis);
		for (node in nodes) {
			var context = new Node_Context(node, scope.hub);
			resolve_block(context);
		}
	}

	function resolve_block(context:Context):Dynamic {
		if (ports[1].connections.length > 0)
			ports[1].get_external_value(context);

    //for (i in 1...ports.length) {
			//ports[i].get_node_value(context);
    //}
    return null;
  }

	override public function to_string():String {
		if (scope.definition.trellis != null)
			return "block " + scope.definition.trellis.name;

		return "block";
	}
}