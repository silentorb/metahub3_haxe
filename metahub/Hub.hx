package;
import haxe.xml.Parser;
import schema.Schema;
import schema.Trellis;
import schema.Property;
import code.Coder;
import code.Scope_Definition;
import code.Scope;
import engine.Node;

@:expose class Hub {
  public var nodes:Array<Node>= new Array<Node>();
  public var schema:Schema;
  public var root_scope:Scope;
  public var root_scope_definition:Scope_Definition;
  public var parser_definition:parser.Definition;

  public function new() {
    nodes.push(null);
    root_scope_definition = new Scope_Definition(this);
    root_scope = new Scope(this, root_scope_definition);
    schema = new Schema();
    create_functions();
  }

  private function load_parser() {
    var boot_definition = new parser.Definition();
    boot_definition.load_parser_schema();
    var context = new parser.Bootstrap(boot_definition);
    var result:parser.Match = cast context.parse(metahub.Macros.insert_file_as_string("metahub/metahub.grammar"), false);
    parser_definition = new parser.Definition();
    parser_definition.load(result.get_data());
  }

  public function create_node(trellis:Trellis):Node {
    var node = new Node(this, nodes.length, trellis);
    nodes.push(node);
    return node;
  }

  function get_node_count() {
    return nodes.length - 1;
  }

  public function load_schema_from_file(url:String) {
    var data = Utility.load_json(url);
    schema.load_trellises(data.trellises);
  }

  public function parse(source:String):Dynamic {
    var parser = new parser.MetaHub_Context(parser_definition);
    return parser.parse(source);
  }

  public function run_data(source:Dynamic) {
    var coder = new Coder(this);

    var expression = coder.convert(source, root_scope_definition);
    expression.resolve(root_scope);
  }

  public function run_code(code:String) {
		var result = parse_code(code);
		if (!result.success)
       throw new Exception("Error parsing code.");

    var match:parser.Match = cast result;
		run_data(match.get_data());
  }

	public function parse_code(code:String) {
		var context = new parser.MetaHub_Context(parser_definition);
    return context.parse(code);
	}

  public function create_functions() {
		var functions = metahub.Macros.insert_file_as_string("metahub/json/core_nodes.json");
    var data = haxe.Json.parse(functions);
    schema.load_trellises(data.trellises);
  }
}