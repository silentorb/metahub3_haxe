package parser;

@:expose class Bootstrap extends Context {

//  public function new() { }

  public override function perform_action(name:String, data:Dynamic, match:Match):Dynamic {
    switch(name) {

      case "and_group":
        return and_group(data);
      case "literal":
        return literal(data);
      case "pattern":
        return pattern(data, match);
      case "start":
        return start(data);
      case "repetition":
        return repetition(data);
      case "reference":
        return reference(data);
      case "regex":
        return regex(data);
      case "rule":
        return rule(data);

      default:
        throw new Exception("Invalid parser method: " + name + ".");
    }
  }

  function literal(data:Dynamic):Dynamic {
//    trace('data', data);
    return data[1];
  }

  function regex(data:Dynamic):Dynamic {
//    trace('data', data);
    return {
    type: "regex",
    text: data[1]
    };
  }

  function reference(data:Dynamic):Dynamic {
    return {
    type: "reference",
    name: data
    };
  }

  function and_group(data:Dynamic):Dynamic {
    return {
    type: "and",
    patterns: data
    };
  }

  function pattern(data:Dynamic, match:Match):Dynamic {
//    trace('pattern:', data);

    var value:Array<Dynamic> = cast data;
    var w = value.length;
    if (data.length == 0)
      return null;
    else if (data.length == 1)
      return data[0];
    else
      return {
      type: "and",
      patterns: data
      };
  }

  function repetition(data:Dynamic):Dynamic {
//    trace('rule', data);
    var settings = data[1];
    var result = {
    type: "repetition",
    pattern: {
    type: "reference",
    name: settings[0]
    },
    divider: {
    type: "reference",
    name: settings[1]
    }
    };

    if (settings.length > 2) {
      Reflect.setField(result, "min", settings[2]);
      if (settings.length > 3) {
        Reflect.setField(result, "max", settings[3]);
      }
    }
    return result;
  }

  function rule(data:Dynamic):Dynamic {
//    trace('rule', data);
    var value:Array<Dynamic> = cast data[4];
    return {
    name: data[0],
    value: value != null && value.length == 1 ? value[0] : value
    };
  }

  function start(data:Dynamic):Dynamic {
    var map:Dynamic < String > = cast {};
//    trace('start', data);

    for (index in Reflect.fields(data)) {
      var item = Reflect.field(data, index);
      Reflect.setField(map, item.name, item.value);
//      map.setField(item.name, item.value);
    }
//    trace('data', data);
    return map; //haxe.Json.parse(haxe.Json.stringify(map);
  }
}