package parser;

@:expose class Definition {
  public var patterns = new Array<Pattern>();
  public var pattern_keys = new Map<String, Pattern>();

  public function new() {
  }

  public function load(source:Dynamic) {
// First create all of the patterns
    for (key in Reflect.fields(source)) {
      var pattern = create_pattern(Reflect.field(source, key));
      pattern.name = key;
      pattern_keys[key] = pattern;
      patterns.push(pattern);
    }

// Then finishing loading each one so that references can be resolved.
    for (key in Reflect.fields(source)) {
//      trace(key);
      initialize_pattern(Reflect.field(source, key), pattern_keys[key]);
    }
  }

  function __create_pattern(source:Dynamic):Pattern {
    if (Std.is(source, String))
      return new Literal(source);

    switch (source.type) {
      case "reference":
        if (!pattern_keys.exists(source.name))
          throw new Exception("There is no pattern named: " + source.name);

        if (Reflect.hasField(source, "action"))
          return new Wrapper(pattern_keys[source.name], source.action);
        else
          return pattern_keys[source.name];

      case "regex":
        return new Regex(source.text);

      case "and":
        return new Group_And();

      case "or":
        return new Group_Or();

      case "repetition":
        return new Repetition();
    }

    trace(source);
    throw new Exception("Invalid parser pattern type: " + source.type + ".");
  }

  public function create_pattern(source:Dynamic):Pattern {
    var pattern = __create_pattern(source);
    if (pattern.type == null)
      pattern.type = source.type != null ? source.type : "literal";

    if (Reflect.hasField(source, "backtrack"))
      pattern.backtrack = source.backtrack;

    return pattern;
  }

  public function initialize_pattern(source:Dynamic, pattern:Pattern) {
    if (source.type == "and" || source.type == "or") {
      var group:Group = cast pattern;
      if (Reflect.hasField(source, "action"))
        group.action = source.action;

      for (key in Reflect.fields(source.patterns)) {
        var child = Reflect.field(source.patterns, key);
        var child_pattern = create_pattern(child);
//        trace("  " + key);
        if (child_pattern == null) {
//          trace(child);
          throw new Exception("Null child pattern!");
        }
        initialize_pattern(child, child_pattern);
        group.patterns.push(child_pattern);
      }
    }
    else if (source.type == "repetition") {
      var repetition:Repetition = cast pattern;
      repetition.pattern = create_pattern(source.pattern);
      initialize_pattern(source.pattern, repetition.pattern);
//      trace("  [pattern]");

//      trace('repi', source);
      repetition.divider = create_pattern(source.divider);
      initialize_pattern(source.divider, repetition.divider);

      if (Reflect.hasField(source, "min"))
        repetition.min = source.min;

      if (Reflect.hasField(source, "max"))
        repetition.min = source.max;

      if (Reflect.hasField(source, "action"))
        repetition.action = source.action;
    }
  }

  public function load_parser_schema() {
    var data = Utility.load_json("metahub/parser.json");
    load(data);
  }
}