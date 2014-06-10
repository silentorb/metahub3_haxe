package code;
import schema.Trellis;
import engine.Node;
import engine.IPort;
import schema.Property_Chain;
/*
class Symbol_With_Path2 implements Symbol {
  public var symbol:Symbol;
  public var property_path:Property_Chain;

  public function new(symbol:Symbol) {
    this.symbol = symbol;
  }

  //public static function create(path:Array<String>, scope_definition:Scope_Definition):Symbol_With_Path {
    //var symbol = scope_definition.find(path[0]);
    //var reference = new Symbol_With_Path(symbol);
		//reference.property_path = symbol.process_path(path);
//
    //return reference;
  //}

  public function get_port(scope:Scope, path:Property_Chain = null):IPort {
		throw new Exception("Not supported");
		//return symbol.get_port(scope, property_path);
    //var node = get_node(scope, path);
    //return node.get_port(property_path[property_path.length - 1]);
  }

	public function get_trellis():Trellis {
		return symbol.get_trellis();
	}

  public function resolve(scope:Scope):Dynamic {
		//var port = symbol.get_port(scope, property_path);
		//return port.value;
		throw new Exception('Not coded yet.');
    //var node = get_node(scope);
    //if (property_path.length > 0)
      //return node.get_value(property_path[property_path.length - 1]);
//
    //return node.id;
  }

	public function set_path(path:Array<String>) {
		if (path.length > 1) {
      property_path = Property_Chain_Helper.from_string(path, get_trellis(), 1);
    }
    else {
      property_path = new Property_Chain();
    }
	}
}*/