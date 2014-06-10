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
  public static function call(id:Functions, args:Iterable<Dynamic>, type:Types):Dynamic {
    switch (id) {
      case Functions.sum:
        return sum(args);

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
}