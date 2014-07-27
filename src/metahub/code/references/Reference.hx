package metahub.code.references;
import metahub.code.Context_Converter;
import metahub.code.Layer;
import metahub.code.Scope;
import metahub.code.Type_Reference;
import metahub.engine.General_Port;
import metahub.schema.Property_Chain;
import metahub.code.symbols.*;

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

	public function get_port(scope:Scope):General_Port {
		throw new Exception("Abstract class.  Not implemented.");
	}

	public function get_layer():Layer {
		return symbol.get_layer();
	}

	public function get_type_reference():Type_Reference {
		return chain != null && chain.length > 0
		? Type_Reference.create_from_property(chain[chain.length - 1])
		: symbol.get_type();
	}

	public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

	public function create_converter(scope:Scope):Context_Converter {
		return null;
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