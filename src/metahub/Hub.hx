package metahub;
import haxe.xml.Parser;
import metahub.code.expressions.Expression;
import metahub.code.functions.Function_Library;
import metahub.code.statements.Statement;
import metahub.engine.Context;
import metahub.engine.General_Port;
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
import metahub.engine.Change;
import metahub.code.Group;
import metahub.code.functions.Functions;
import metahub.schema.Kind;
import haxe.Json;

@:expose class Hub {
  var nodes:Map<Int, Node> = new Map<Int, Node>();
  public var internal_nodes:Array<INode>= new Array<INode>();
  public var schema:Schema;
  public var root_scope:Scope;
  public var root_scope_definition:Scope_Definition;
  public var parser_definition:metahub.parser.Definition;
	static var remove_comments = ~/#[^\n]*/g;
	public var metahub_namespace:Namespace;
	public var node_factories = new Array < Hub->Int->Trellis->Node > ();
	public var function_library:Function_Library;
	public var history = new History();
	public var constraints = new Array<Group>();
	var queue = new Array<Change>();
	var entry_node:Node = null;
	public var max_steps = 100;
	var node_count:Int;

  public function new() {
    nodes[0] = null;
		node_count = 1;

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

	public function add_change(node:INode, index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		var i = queue.length;
		while (--i >= 0) {
			if (queue[i].node == node) {
				queue.splice(i, 1);
			}
		}
		var change = new Change(node, index, value, context, source);
		queue.push(change);
	}

	public function set_entry_node(node:Node) {
		if (entry_node == null)
			entry_node = node;
	}

	//public function unset_entry_node(node:Node) {
		//if (entry_node == node)
			//entry_node = null;
	//}

	public function run_change_queue(node:Node) {
		if (entry_node != node)
			return;

		var steps = 0;
		while (queue.length > 0) {
			var change = queue.shift();
			change.run();
			if (++steps > max_steps)
				throw new Exception("Max steps of " + max_steps + " was reached.");
		}

		entry_node = null;
	}

  private function load_parser() {
    var boot_definition = new metahub.parser.Definition();
    boot_definition.load_parser_schema();
    var context = new metahub.parser.Bootstrap(boot_definition);
    var result = context.parse(metahub.Macros.insert_file_as_string("inserts/metahub.grammar"), false);
		if (result.success) {
			var match:Match = cast result;
			parser_definition = new Definition();
			parser_definition.load(match.get_data());
		}
		else {
			throw new Exception("Error loading parser.");
		}
  }

  public function create_node(trellis:Trellis):Node {
		var node:Node = null;
		var id = ++node_count;
		for (factory in node_factories) {
			node = factory(this, id, trellis);
			if (node != null)
				break;
		}

		if (node == null)
			throw new Exception("Could not find valid factory to create node of type " + trellis.name + ".");

		add_node(node);
    return node;
  }

	function add_node(node:Node) {
		if (nodes.exists(node.id))
			throw new Exception("Node " + node.id + " already exists!");

    nodes[node.id] = node;
	}

	public function add_internal_node(node:INode) {
    internal_nodes.push(node);
	}

	public function get_node(id:Int):Node {
		if (!nodes.exists(id))
		//if (id < 1 || id >= nodes.length)
			throw new Exception("There is no node with an id of " + id + ".");

		return nodes[id];
	}

  public function get_node_count() {
    return node_count;
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

  public function run_data(source:Dynamic):Statement {
    var coder = new Coder(this);
    return coder.convert_statement(source, root_scope_definition);
  }

  public function run_code(code:String) {
		var result = parse_code(code);
		if (!result.success) {
       throw new Exception("Syntax Error at " + result.end.y + ":" + result.end.x);
		}
    var match:metahub.parser.Match = cast result;
		var statement = run_data(match.get_data());
    statement.resolve(root_scope);
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
		var functions = Macros.insert_file_as_string("inserts/core_nodes.json");
    var data = haxe.Json.parse(functions);
    schema.load_trellises(data.trellises, new Load_Settings(metahub_namespace));
  }
}