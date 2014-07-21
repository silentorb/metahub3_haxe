package metahub.parser;
import metahub.code.functions.Functions;

@:expose class MetaHub_Context extends Context {

	private static var function_map:Map<String, Functions>;

  public function new(definition) {
		super(definition);

		if (function_map == null) {
			function_map = new Map<String, Functions>();
			var map = {
				"+": Functions.add,
				"-": Functions.subtract,

				"=": Functions.equals,
				"<": Functions.lesser_than,
				">": Functions.greater_than,
				"<=": Functions.lesser_than_or_equal_to,
				">=": Functions.greater_than_or_equal_to,
			}

			for (i in Reflect.fields(map)) {
				function_map[i] = Reflect.field(map, i);
			}
		}
	}

  public override function perform_action(name:String, data:Dynamic, match:Match):Dynamic {
    var name = match.pattern.name;
    switch(name) {
      case "start":
        return start(data);

      case "create_symbol":
        return create_symbol(data);

      case "create_node":
        return create_node(data);

      case "create_constraint":
        return create_constraint(data);

      case "expression":
        return expression(data, match);

      case "method":
        return method(data);

      case "reference":
        return reference(data);

      case "set_property_block":
        return set_property_block(data);

      case "set_property":
        return set_property(data);

      case "set_values":
        return set_values(data);

      case "trellis_scope":
        return trellis_scope(data);

      case "constraint_block":
        return constraint_block(data);

      case "constraint":
        return constraint(data);

//      case "path":
//        return path(data);

      case "string":
        return data[1];

      case "int":
        return Std.parseInt(data);

      case "value":
        return value(data);

//      default:
//        throw new Exception("Invalid parser method: " + name + ".");
    }

    return data;
  }

  static function start(data:Dynamic):Dynamic {
    return {
    "type": "block",
    "expressions": data[1]
    };
  }

  static function create_symbol(data:Dynamic):Dynamic {
    return {
    type: "symbol",
    name: data[2],
    expression: data[6]
    };
  }

  static function expression(data:Dynamic, match:Match):Dynamic {
    if (data.length < 2)
      return data[0];

    var rep_match:Repetition_Match = cast match;
    var operator:String = cast rep_match.dividers[0].matches[1].get_data();
    //trace('op', operator);
    var operators = {
    '+': 'sum',
    '-': 'subtract'
    };
    return {
    type: "function",
    "name": Reflect.field(operators, operator),
    "inputs": data
    }
  }

	static function method(data:Dynamic):Dynamic {
		return {
    type: "function",
    "name": data[1],
    "inputs": []
    }
	}

  static function create_constraint(data:Dynamic):Dynamic {
    return {
    type: "specific_constraint",
    path: data[0],
    expression: data[4]
    };
  }

  static function create_node(data:Dynamic):Dynamic {
    var result:Dynamic = cast {
    type: "node",
    trellis: data[2]
    };

    if (data[4] != null && data[4].length > 0) {
      result.set = data[4][0];
    }

    return result;
  }

//  static function path(data:Dynamic):Dynamic {
//    trace('data', data);
//    return data;
//  }

  static function reference(data:Dynamic):Dynamic {
		var reference = {
			type: "reference",
			path: data[0]
		};

		var methods:Array<Dynamic> = cast data[1];
		if (methods.length > 0) {
			var method = methods[0];
			method.inputs.unshift(reference);
			return method;
		}
		else {
			return reference;
		}
  }

  static function set_property_block(data:Dynamic):Dynamic {
    var result:Dynamic = {}
    var items:Array<Dynamic> = cast data[2];

    for (item in items) {
      result[item[0]] = item[1];
    }

    return result;
  }

  static function set_property(data:Dynamic):Dynamic {
    return [ data[0], data[4] ];
  }

  static function set_values(data:Dynamic):Dynamic {
    return {
    type: "set",
    "path": data[2],
    "assignments": data[4]
    };
  }

  static function value(data:Dynamic):Dynamic {
    return {
    type: "literal",
    value: data
    };
  }

	static function trellis_scope(data:Dynamic):Dynamic {
    return {
			"type": "trellis_scope",
			"path": data[0],
			"statements": data[2]
		};
  }

	static function constraint_block(data:Dynamic):Dynamic {
    return data[2];
  }

	static function constraint(data:Dynamic):Dynamic {
    return {
			type: "constraint",
			path: [ data[0] ],
			expression: {
				type: "function",
				"name": Std.string(function_map[data[2]]),
				"inputs": [data[4]]
			}
    };
  }
}