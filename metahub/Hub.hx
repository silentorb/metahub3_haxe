package;
import haxe.ds.Vector;
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
	static var remove_comments = ~/#[^\n]*/g;

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

	public function get_node(id:Int):Node {
		if (id < 0 || id >= nodes.length)
			throw new Exception("There is no node with an id of " + id + ".");

		return nodes[id];
	}

  function get_node_count() {
    return nodes.length - 1;
  }

  public function load_schema_from_file(url:String) {
    var data = Utility.load_json(url);
    schema.load_trellises(data.trellises);
  }

  //public function parse(source:String):Dynamic {
    //var parser = new parser.MetaHub_Context(parser_definition);
		//var without_comments = remove_comments.replace(source, '');
		//trace('without_comments', without_comments);
    //return parser.parse(without_comments);
  //}

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
		if (parser_definition == null) {
			load_parser();
		}
		var context = new parser.MetaHub_Context(parser_definition);
		var without_comments = remove_comments.replace(code, '');
		//trace('without_comments', without_comments);
    return context.parse(without_comments);
	}

  public function create_functions() {
		var functions = metahub.Macros.insert_file_as_string("metahub/json/core_nodes.json");
    var data = haxe.Json.parse(functions);
    schema.load_trellises(data.trellises);
  }
}