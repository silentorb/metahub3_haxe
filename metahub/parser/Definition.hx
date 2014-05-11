package parser;

class Definition {
  var patterns = new Map<String, Pattern>();

  public function new() {

  }

  public function load(source:Dynamic) {
   // First create all of the patterns
    for (key in Reflect.fields(source)) {
      patterns[key] = load_pattern(Reflect.field(source));
    }

    // Then finishing loading each one so that references can be resolved.
    for (key in Reflect.fields(source)) {
      initialize_pattern(Reflect.field(source), patterns[key]);
    }
  }

  public function load_pattern(source:Dynamic):Pattern {
      return new Literal(source);
    }
  }

  public function load_parser_schema() {
    var text = '
  {
    "start": [

    ],

    "id": "\w+",

    "whitespace": "\s+",

    "rule": [
      {
        "type": "reference",
        "pattern": "id"
      },
      {
        "type": "reference",
        "pattern": "whitespace"
      },
      "=",

    ]
  }
  ';
    var data = haxe.Json.parse(text);
    load(data);
  }
}