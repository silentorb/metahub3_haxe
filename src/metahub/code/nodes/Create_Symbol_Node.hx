package metahub.code.nodes;
import metahub.code.Path;
import metahub.code.symbols.Symbol;
import metahub.engine.Context;
import metahub.engine.General_Port;
import metahub.engine.INode;
import metahub.engine.Node;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Create_Symbol_Node implements INode{
	var port:General_Port;
	var input:General_Port;
	var symbol:Symbol

	public function new(input:General_Port,symbol:Symbol) {
		this.input = input;
		this.simple = symbol;
		port = new General_Port(this, 0);
	}

	public function get_port(index:Int):General_Port {
		return port;
	}
	
	public function get_port_count():Int {
		return 1;
	}
	
  public function get_value(index:Int, context:Context):Dynamic {
		
		return path.resolve(node);
	}

  public function set_value(index:Int, value:Dynamic, context:Context, source:General_Port = null) {
		throw new Exception('Not implementednid');
	}
			
	public function to_string():String {
		return "let " + symbol.name + " =";
	}
}