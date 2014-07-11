package metahub.code;

import metahub.engine.INode;
import metahub.engine.IPort;
import metahub.engine.Port;
import metahub.schema.Kind;
import metahub.schema.Types;

enum Functions {
  none;
  sum;
  subtract;
}

class Function_Calls {
  public static function call(id:String, args:List<Dynamic>, type:Kind):Dynamic {
		//trace(Reflect.fields(Function_Calls));
		if (!Reflect.hasField(Function_Calls, id))
			throw new Exception("Invalid function name " + id + ".");

		var func = Reflect.field(Function_Calls, id);
		var kind:Dynamic = type;
		return Reflect.callMethod(Function_Calls, func, [ args ].concat(kind));
    //switch (id) {
      //case Functions.sum:
        //return sum(args);
      //case Functions.subtract:
        //return subtract(args);
//
      //default:
    //}
//
		//throw new Exception("Invalid function id " + id + ".");
  }

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