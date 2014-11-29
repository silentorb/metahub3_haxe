package metahub.parser;
import metahub.code.functions.Functions;

typedef Assignment_Source = {
	type:String,
	path:Array<String>,
	expression:Dynamic,
	?modifier:String
}

typedef Reference_Or_Function = {
	type:String,
	//?path:Array<String>,
	?name:String,
	?expression:Dynamic,
	?inputs:Array<Dynamic>
}

@:expose class MetaHub_Context extends Context {

	private static var function_map:Map<String, Functions>;

  public function new(definition) {
		super(definition);

		if (function_map == null) {
			function_map = new Map<String, Functions>();
			var map = {
				"+": Functions.add,
				"-": Functions.subtract,
				"*": Functions.multiply,
				"/": Functions.divide,

				"+=": Functions.add_equals,
				"-=": Functions.subtract_equals,
				"*=": Functions.multiply_equals,
				"/=": Functions.divide_equals,

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
        return reference(data, cast match);

      case "long_block":
        return long_block(data);

      case "set_property":
        return set_property(data);

      case "new_scope":
        return new_scope(data);

      case "constraint_block":
        return constraint_block(data);

      case "constraint":
        return constraint(data);

      case "condition":
        return condition(data);

      case "conditions":
        return conditions(data, match);

      case "condition_block":
        return condition_block(data);

      case "if":
        return if_statement(data);

      case "string":
        return data[1];

			case "bool":
				return data == "true" ? true : false;

      case "int":
        return Std.parseInt(data);

      case "value":
        return value(data);

      case "optional_block":
        return optional_block(data);

			case "set_weight":
        return set_weight(data);

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

    var operators = {
			'+': 'add',
			'-': 'subtract',
			'*': 'multiply',
			'/': 'divide',
			'+=': 'add_equals',
			'-=': 'subtract_equals',
			'*=': 'multiply_equals',
			'/=': 'divide_equals'
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

	static function condition(data:Dynamic):Dynamic {
		return {
			type: "condition",
			"first": data[0],
			"operator": Std.string(data[2][0]),
			//"operator": Std.string(function_map[data[2][0]]),
			"second": data[4]
    }
	}

	static function optional_block(data:Dynamic):Dynamic {
		return data[1];
	}

	static function conditions(data:Dynamic, match:Match):Dynamic {
		var rep_match:Repetition_Match = cast match;
		if (data.length > 1) {
			var symbol:String = rep_match.dividers[0].matches[1].get_data();
			var divider:String = null;
			switch(symbol) {
				case "&&": divider = "and";
				case "||": divider = "or";
				default: throw new Exception("Invalid condition group joiner: " + symbol + ".");
			}
			return {
				type: "conditions",
				"conditions": data,
				"mode": divider
			}
		}
		else {
			return data[0];
		}
	}

	static function condition_block(data:Dynamic):Dynamic {
		return data[2];
	}

	static function if_statement(data:Dynamic):Dynamic {
		return {
			type: "if",
			"condition": data[2],
			"action": data[4]
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
			type: "create_node",
			trellis: data[2]
    };

    if (data[3] != null && data[3].length > 0) {
			result.block = data[3][0];
      //result.set = data[4][0];
    }

    return result;
  }

  static function reference(data:Dynamic, match:Repetition_Match):Dynamic {
		var dividers = Lambda.array(Lambda.map(match.dividers, function(d) { return d.matches[0].get_data(); } ));
//
		//if (data.length == 1) {
			//return {
				//type: "reference",
				//path: [ data[0] ]
			//}
		//}

		var tokens:Array<Reference_Or_Function> = [
			{
				type: "reference",
				name: data[0]
			}
		];

		for (i in 1...data.length) {
			var token = data[i];
			var divider = dividers[i - 1];
			if (divider == '.') {
				tokens.push({
					type: "reference",
					name: token
				});
			}
			else if (divider == '|') {
				tokens.push({
					type: "function",
					name: token
				});
			}
			else {
				throw new Exception("Invalid divider: " + divider);
			}
		}

		var result = {
			type: "path",
			children: tokens
		};

		return result;
  }

  static function long_block(data:Dynamic):Dynamic {
		return {
			type: "block",
			expressions: data[2]
		};
  }

  static function set_property(data:Dynamic):Dynamic {
    var result:Assignment_Source = {
			type: "set_property",
			path: data[0],
			expression: data[6],
		};

		if (data[4].length > 0)
			result.modifier = Std.string(function_map[data[4][0]]);

		return result;
  }

  static function set_weight(data:Dynamic):Dynamic {
		return {
			type: "weight",
			weight: data[0],
			statement: data[4]
		}
	}

  static function value(data:Dynamic):Dynamic {
    return {
    type: "literal",
    value: data
    };
  }

	static function new_scope(data:Dynamic):Dynamic {
    return {
			"type": "new_scope",
			"path": data[0],
			"expression": data[2]
		};
  }

	static function constraint_block(data:Dynamic):Dynamic {
    return data[2];
  }

	static function constraint(data:Dynamic):Dynamic {
    return {
			type: "constraint",
			reference: data[0],
			//operator: Std.string(function_map[data[2]]),
			operator: data[2],
			expression: data[4]
    };
  }
}