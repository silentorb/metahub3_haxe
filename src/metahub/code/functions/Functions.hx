package metahub.code.functions;

import metahub.code.nodes.INode;
import metahub.engine.General_Port;
import metahub.engine.General_Port;
import metahub.schema.Kind;

enum Functions {
  none;

	// Comparison
	equals;
  lesser_than;
  greater_than;
  lesser_than_or_equal_to;
  greater_than_or_equal_to;

	// Operators
  add;
  subtract;
	multiply;
	divide;

	add_equals;
  subtract_equals;
	multiply_equals;
	divide_equals;

	// List Functions
	count;
	first;
	map;
}

class Function_Calls2 {

  static function sum(args:Iterable<Dynamic>, type:Kind):Dynamic {
    var total = 0;
    for (arg in args) {
			var value:Int = cast arg;
      total += value;
    }

    return total;
  }

	static function subtract(args:List<Dynamic>, type:Kind):Dynamic {
    var total:Int = 0;
		var numbers:Iterable<Int> = args.first();
		var i = 0;
    for (arg in numbers) {
			var value:Int = cast arg;
			if (i == 0) {
				i = 1;
				total = value;
			}
			else {
				total -= value;
			}
    }

    return total;
  }

	static function count(args:List<Dynamic>, type:Kind):Dynamic {
		var result = args.first()[0].length;
		trace('count', result);
		return result;

  }
}