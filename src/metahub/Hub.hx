package metahub;
import haxe.xml.Parser;
import metahub.meta.Coder;
import metahub.meta.types.Expression;
import metahub.parser.Definition;
import metahub.parser.Match;
import metahub.schema.Load_Settings;
import metahub.schema.Namespace;
import metahub.schema.Schema;
import metahub.schema.Trellis;
import metahub.schema.Property;

import metahub.schema.Kind;
import haxe.Json;

@:expose class Hub {
  public var schema:Schema;
  public var parser_definition:metahub.parser.Definition;
	static var remove_comments = ~/#[^\n]*/g;
	public var metahub_namespace:Namespace;
	public var max_steps = 100;

	static var instances = new Array<Hub>();

  public function new() {
		instances.push(this);
 
		metahub_namespace = schema.add_namespace('metahub');
    load_internal_trellises();

		//var math_library = new Math_Library();
		//metahub_namespace.children['Math'] = schema.add_namespace('Math', math_library);
		//math_library.load(this);
  }

	//public function add_change(node:INode, index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		//var i = queue.length;
		//while (--i >= 0) {
			//if (queue[i].node == node) {
				//queue.splice(i, 1);
			//}
		//}
		//var change = new Pending_Change(node, index, value, context, source);
		//queue.push(change);
	//}
//
	//public function set_entry_node(node:Node) {
		//if (entry_node == null)
			//entry_node = node;
	//}

	//public function unset_entry_node(node:Node) {
		//if (entry_node == node)
			//entry_node = null;
	//}

	//public function run_change_queue(node:Node) {
		//if (entry_node != node)
			//return;
//
		//var steps = 0;
		//while (queue.length > 0) {
			//var change = queue.shift();
			//change.run();
			//if (++steps > max_steps)
				//throw new Exception("Max steps of " + max_steps + " was reached.");
		//}
//
		//entry_node = null;
	//}

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

  //public function create_node(trellis:Trellis):Node {
		//var register = !trellis.is_value;
		//var node:Node = null;
		//var id = register ? ++node_count : 0;
		////if (id != 0)
			////trace("Creating " + trellis.name + " : " + id);
//
		//#if trace
			//var entry = new Entry("Create " + trellis.name + " " + id);
			//history.add(entry);
		//#end
//
		//for (factory in node_factories) {
			//node = factory(this, id, trellis);
			//if (node != null)
				//break;
		//}
//
		//if (node == null)
			//throw new Exception("Could not find valid factory to create node of type " + trellis.name + ".");
//
		//if (register)
			//add_node(node);
//
		//new_nodes.push(node);
//
		////node.initialize_values2();
		//if (!trellis.is_value) {
			//node.update_values();
			//node.update_on_create();
		//}
//
    //return node;
  //}

	//function add_node(node:Node) {
		//if (nodes.exists(node.id))
			//throw new Exception("Node " + node.id + " already exists!");
//
		////for (trellis in schema.trellises) {
			////trellis_nodes[trellis.name] = new Array<Node>();
		////}
//
    //nodes[node.id] = node;
//
		//var tree = node.trellis.get_tree();
		//for (t in tree) {
			//if (!trellis_nodes.exists(t.name))
				//trellis_nodes[t.name] = new Array<Node>();
//
			//trellis_nodes[t.name].push(node);
		//}
	//}
//
	//public function add_internal_node(node:INode) {
    //internal_nodes.push(node);
	//}
//
	//public function get_node(id:Int):Node {
		//if (!nodes.exists(id))
		////if (id < 1 || id >= nodes.length)
			//throw new Exception("There is no node with an id of " + id + ".");
//
		//return nodes[id];
	//}
//
  //public function get_node_count() {
    //return node_count;
  //}
//
	//public function get_nodes_by_trellis(trellis:Trellis):Array<Node> {
		//return trellis_nodes.exists(trellis.name)
			//? trellis_nodes[trellis.name]
			//: [];
	//}

  public function load_schema_from_file(url:String, namespace:Namespace, auto_identity:Bool = false) {
    var data = Utility.load_json(url);
    load_schema_from_object(data, namespace, auto_identity);
  }

	public function load_schema_from_string(json:String, namespace:Namespace, auto_identity:Bool = false) {
    var data = Json.parse(json);
    load_schema_from_object(data, namespace, auto_identity);
  }

	public function load_schema_from_object(data:Dynamic, namespace:Namespace, auto_identity:Bool = false) {
    schema.load_trellises(data.trellises, new Load_Settings(namespace, auto_identity));
		if (Reflect.hasField(data, 'is_external') && Reflect.field(data, 'is_external') == true)
			namespace.is_external = true;
	
		for (key in Reflect.fields(data)) {
			if (key == 'trellises')
				continue;
				
			namespace.additional[key] = Reflect.field(data, key);
		}
  }

  public function run_data(source:Dynamic):Expression {
    var coder = new Coder(this);
    return coder.convert_statement(source, null);
  }

  public function run_code(code:String) {
		var result = parse_code(code);
		if (!result.success) {
       throw new Exception("Syntax Error at " + result.end.y + ":" + result.end.x);
		}
    var match:metahub.parser.Match = cast result;
		var statement = run_data(match.get_data());

		//trace(graph_expressions(statement));

		//#if trace
			//history.new_tree();
		//#end

		//var port = statement.to_port(root_scope, new Group(null), null);
		//trace(graph_nodes(port.node));

		//#if trace
			//history.new_tree();
		//#end

		//port.get_node_value(new Empty_Context(this));
		//history.start_finished();
		//return port;
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

	//public function get_increment():INode {
		//if (interval_node == null) {
			//interval_node = new Block_Node(new Scope(this, root_scope_definition), new Group(null));
		//}
//
		//return interval_node;
	//}

	//public function connect_to_increment(port:General_Port) {
		//var node = get_increment();
		//node.get_port(1).connect(port);
	//}
//
	//public function increment(layer:Int = 10000) {
		//var node = get_increment();
		//node.get_value(0, new Empty_Context(this));
		//new_nodes = [];
	//}

	//public static function get_node_label(node:INode, port:General_Port = null) {
		//var trellis:Trellis = Type.getClassName(Type.getClass(node)) == "metahub.schema.Trellis"
			//? cast node
			//: null;
//
		//return trellis != null && port != null
			//? trellis.properties[port.id].fullname()
			//: node.to_string();
	//}
//
	//public static function graph_nodes(node:INode, depth:Int = 0, used:Array<INode> = null, port:General_Port = null):String {
		//if (used == null)
			//used = [];
//
		////var maximum_depth = 50;
		//var trellis:Trellis = Type.getClassName(Type.getClass(node)) == "metahub.schema.Trellis"
			//? cast node
			//: null;
//
		//var tabbing = " ";
		//var result = "";
		//var padding = "";
		//for (i in 0...depth) {
			//padding += tabbing;
		//}
		//var label = get_node_label(node, port);
//
		//if (Reflect.hasField(node, 'id'))
			//label = "#" + Reflect.field(node, 'id') + " " + label;
//
		//result += padding + label + "\n";
//
		//if (used.indexOf(node) != -1 || trellis != null)
			//return result;
//
		//used.push(node);
//
		////if (depth > maximum_depth) {
			////return result + padding + tabbing + "EXCEEDED MAXIMUM DEPTH OF " + maximum_depth + ".\n";
		////}
		//for (i in 1...node.get_port_count()) {
			//var port = node.get_port(i);
			//var deeper = 0;
			//if (node.get_port_count() > 2) {
				//result += padding + tabbing + i + "\n";
				//deeper = 1;
			//}
			//for (connection in port.connections) {
				//result += graph_nodes(connection.node, depth + 1 + deeper, used, connection);
			//}
		//}
//
		//if (depth == 0) {
			//result = "Graphed " + used.length + " nodes:\n\n" + result;
		//}
//
		//return result;
	//}
//
	//public static function graph_expressions(expression:Expression, depth:Int = 0, used:Array<Expression> = null):String {
		//if (used == null)
			//used = [];
//
		//var tabbing = " ";
		//var result = "";
		//var padding = "";
		//for (i in 0...depth) {
			//padding += tabbing;
		//}
//
		//if (expression == null)
			//return padding + "null\n";
//
		//result += padding + expression.to_string() + "\n";
		//used.push(expression);
//
		//for (child in expression.children) {
			//result += graph_expressions(child, depth + 1, used);
		//}
//
		//if (depth == 0) {
			//result = "Graphed " + used.length + " expressions:\n\n" + result;
		//}
//
		//return result;
	//}
//
	//public function is_node_new(node:Node) {
		//return this.new_nodes.indexOf(node) > -1;
	//}
}