package code.references;
import code.Scope;
import schema.Property_Chain;
import code.symbols.*;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Reference<S : Symbol> {
  var symbol:S;
  public var chain:Property_Chain;

	public function new(symbol:S, chain:Property_Chain = null) {
		this.symbol = symbol;
		this.chain = chain;
	}

	public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

	//public static function create_from_path(symbol:Symbol, path:Array<String>):Reference {
		//trace(Type.getClassName(Type.getClass(symbol)));
		//var trellis = symbol.get_trellis();
		//var chain = Property_Chain_Helper.from_string(path, trellis);
		//var symbol_type = Type.getClassName(Type.getClass(symbol));
//
		//if (symbol_type == Type.getClassName(Local_Symbol))
			//return new Node_Reference(symbol, chain);
//
		//if (symbol_type == Type.getClassName(Trellis_Symbol))
			//return new Trellis_Reference(symbol, chain);
//
		//if (symbol_type == Type.getClassName(Property_Symbol))
			//return new Property_Reference(symbol, chain);
//
		//throw new Exception("Not finished.");
	//}

	//public static function create_schema_symbol_from_path(symbol:ISchema_Symbol, path:Array<String>):Reference {
		//trace(Type.getClassName(Type.getClass(symbol)));
		//var trellis = symbol.get_trellis();
		//var chain = Property_Chain_Helper.from_string(path, trellis);
		//var symbol_type = Type.getClassName(Type.getClass(symbol));
//
		//if (symbol_type == Type.getClassName(Trellis_Symbol))
			//return new Trellis_Reference(symbol, chain);
//
		//if (symbol_type == Type.getClassName(Property_Symbol))
			//return new Property_Reference(symbol, chain);
//
		//throw new Exception("Invalid symbol.");
	//}
}