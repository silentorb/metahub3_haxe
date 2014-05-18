package;
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
    root_scope_definition = new Scope_Definition();
    root_scope = new Scope(this, root_scope_definition);
    schema = new Schema();
    create_functions();

    initialize_parser();
  }

  private function initialize_parser() {
    var boot_definition = new parser.Definition();
    boot_definition.load_parser_schema();
    var context = new parser.Bootstrap(parser_definition);
    var data = context.parse("");
    parser_definition = new parser.Definition();
    parser_definition.load(data);
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

  public function run(source:Dynamic) {
    var coder = new Coder(this);

    var expression = coder.convert(source, root_scope_definition);
    expression.resolve(root_scope);
  }
//
//  public function create_function(name:String, inputs, outputs, action) {
//    var trellis = new Trellis(name, schema);
//    schema.add_trellis(trellis);
//    return trellis;
//  }

  public function create_functions() {
    var functions = '
{
  "trellises": {
    "string":{
      "properties":{
        "output":{
          "type":"string"
        }
      }
    },
    "int":{
      "properties":{
        "output":{
          "type":"int"
        }
      }
    },
    "function": {},
    "sum": {
      "parent":"function",
      "properties": {
        "output": {
          "type": "int",
          "multiple": "true"
        },
        "input": {
          "type": "int"
        }
      }
    }
  }
}
';

    var data = haxe.Json.parse(functions);
    schema.load_trellises(data.trellises);
  }
}