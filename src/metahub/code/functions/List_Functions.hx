package metahub.code.functions;
import metahub.code.nodes.Property_Node;
import metahub.code.nodes.Resolution;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class List_Functions extends Function {

	override public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {

	}

	override private function forward(args:Array<Dynamic>):Dynamic {
		var first:Array<Dynamic> = args[0];
		var second:Dynamic = args[1];

		switch (func) {
			case Functions.add:
				return first.concat([second]);

			case Functions.first:
				return first.length > 0 ? first[0] : null;

			default:
				throw new Exception("Invalid function.");

		}

		return first;
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		switch (func) {

			default:
				throw new Exception("Invalid function.");

		}
		return null;
	}

	override public function resolve_token_reverse(value:Dynamic, previous:Dynamic):Resolution {
		var property_node:Property_Node = cast previous;
		var property = property_node.property;

		switch (func) {
			case Functions.first:
				var node:Node = cast value;
				var list:Array<Dynamic> = node.get_value(property.other_property.id);
				if (list == null)
					return { success: false, value: null };

				if (list.indexOf(node) > -1)
					return { success: true, value: list };

				return { success: false, value: null };

			default:
				throw new Exception("Invalid function.");

		}
	}

	override public function resolve_token(value:Dynamic, is_last:Bool):Resolution {
		switch (func) {
			case Functions.first:
				var list:Array<Dynamic> = cast value;
				if (list.length == 0)
					return { success: false, value: null };

				return { success: true, value: list[0] };

			default:
				throw new Exception("Invalid function.");

		}
	}
}