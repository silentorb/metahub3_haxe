package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Count extends Function {

	override private function forward(args:Array<Dynamic>):Dynamic {
		return args[0].length;
	}

	override private function reverse(value:Dynamic, args:Array<Dynamic>):Dynamic {
		var length:Int = value;
		var old:Array<Dynamic> = args[0];
		if (old.length == length) {
			return old;
		}

		if (old.length > length) {
			throw new Exception("Not yet implemented.");
		}

		var result = old.copy();
		var discrepancy = length - result.length;
		for (i in 0...discrepancy) {
			var node = this.hub.create_node(this.signature[1].trellis);
			result.push(node);
		}

		return result;
	}
}