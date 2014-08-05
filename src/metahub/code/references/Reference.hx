package metahub.code.references;
import metahub.code.Context_Converter;
import metahub.code.Layer;
import metahub.code.Scope;
import metahub.code.Type_Signature;
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

	public function resolve_port(scope:Scope):General_Port {
		throw new Exception("Abstract class.  Not implemented.");
	}

	public function get_layer():Layer {
		return symbol.get_layer();
	}

	public function get_type_reference():Type_Signature {
		return chain != null && chain.length > 0
		? Type_Signature.from_property(chain[chain.length - 1])
		: symbol.get_type();
	}

	public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

	public function create_converter(scope:Scope):Context_Converter {
		return null;
	}

}