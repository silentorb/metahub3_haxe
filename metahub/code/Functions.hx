package code;

import engine.INode;
import engine.IPort;
import engine.Port;
import schema.Types;

enum Functions {
  none;
  sum;
  subtract;
}

class Function_Calls {
  public static function call(id:Functions, args:List<Dynamic>, type:Types):Dynamic {
    switch (id) {
      case Functions.sum:
        return sum(args);
      case Functions.subtract:
        return subtract(args);

      default:
    }

		throw new Exception("Invalid function id " + id + ".");
  }

  static function sum(args:Iterable<Dynamic>):Dynamic {
    var total = 0;
    for (arg in args) {
			var value:Int = cast arg;
      total += value;
    }

    return total;
  }

	static function subtract(args:List<Dynamic>):Dynamic {
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
}