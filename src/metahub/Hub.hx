package metahub;
import haxe.ds.Vector;
import haxe.xml.Parser;
import metahub.code.functions.Function_Library;
import metahub.parser.Definition;
import metahub.parser.Match;
import metahub.schema.Load_Settings;
import metahub.schema.Namespace;
import metahub.schema.Schema;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.code.Coder;
import metahub.code.Scope_Definition;
import metahub.code.Scope;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.code.functions.Functions;
import metahub.schema.Kind;
import haxe.Json;

@:expose class Hub {
  public var nodes:Array<Node>= new Array<Node>();
  public var internal_nodes:Array<INode>= new Array<INode>();
  public var schema:Schema;
  public var root_scope:Scope;
  public var root_scope_definition:Scope_Definition;
  public var parser_definition:metahub.parser.Definition;
	static var remove_comments = ~/#[^\n]*/g;
	public var metahub_namespace:Namespace;
	public var node_factories = new Array < Hub->Int->Trellis->Node > ();
	public var function_library:Function_Library;

  public function new() {
    nodes.push(null);

		node_factories.push(function (hub, id, trellis) {
			return new Node(hub, id, trellis);
		});

    root_scope_definition = new Scope_Definition(this);
    root_scope = new Scope(this, root_scope_definition);
    schema = new Schema();
		metahub_namespace = schema.add_namespace('metahub');
    load_internal_trellises();
		function_library = new Function_Library(this);
  }

  private function load_parser() {
    var boot_definition = new metahub.parser.Definition();
    boot_definition.load_parser_schema();
    var context = new metahub.parser.Bootstrap(boot_definition);
    var result:Match = cast context.parse(metahub.Macros.insert_file_as_string("metahub.grammar"), false);
    parser_definition = new Definition();
    parser_definition.load(result.get_data());
  }

  public function create_node(trellis:Trellis):Node {
		var node:Node = null;
		for (factory in node_factories) {
			node = factory(this, nodes.length, trellis);
			if (node != null)
				break;
		}

		if (node == null)
			throw new Exception("Could not find valid factory to create node of type " + trellis.name + ".");

		add_node(node);
    return node;
  }

	public function add_node(node:Node) {
    nodes.push(node);
	}

	public function add_internal_node(node:INode) {
    internal_nodes.push(node);
	}

	public function get_node(id:Int):Node {
		if (id < 0 || id >= nodes.length)
			throw new Exception("There is no node with an id of " + id + ".");

		return nodes[id];
	}

  function get_node_count() {
    return nodes.length - 1;
  }

  public function load_schema_from_file(url:String, namespace:Namespace, auto_identity:Bool = false) {
    var data = Utility.load_json(url);
    schema.load_trellises(data.trellises, new Load_Settings(namespace, auto_identity));
  }

	public function load_schema_from_string(json:String, namespace:Namespace, auto_identity:Bool = false) {
    var data = Json.parse(json);
    schema.load_trellises(data.trellises, new Load_Settings(namespace, auto_identity));
  }

	public function load_schema_from_object(data:Dynamic, namespace:Namespace, auto_identity:Bool = false) {
    schema.load_trellises(data.trellises, new Load_Settings(namespace, auto_identity));
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

    var match:metahub.parser.Match = cast result;
		run_data(match.get_data());
  }

	public function parse_code(code:String) {
		if (parser_definition == null) {
			load_parser();
		}
		var context = new metahub.parser.MetaHub_Context(parser_definition);
		var without_comments = remove_comments.replace(code, '');
		//trace('without_comments', without_comments);
    return context.parse(without_comments);
	}

  public function load_internal_trellises() {
		var functions = Macros.insert_file_as_string("json/core_nodes.json");
    var data = haxe.Json.parse(functions);
    schema.load_trellises(data.trellises, new Load_Settings(metahub_namespace));
  }
}