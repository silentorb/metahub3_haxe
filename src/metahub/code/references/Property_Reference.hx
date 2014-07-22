package metahub.code.references;
import metahub.code.symbols.Property_Symbol;
import metahub.engine.IPort;
import metahub.schema.Property_Port;
import metahub.code.symbols.ISchema_Symbol;
import metahub.schema.Property;
using metahub.schema.Property_Chain;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Property_Reference extends Reference<ISchema_Symbol> {

	override public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

	override public function get_port(scope:Scope):IPort {
		var property = get_property(scope);
		var port = property.port;
		if (port == null) {
			port = property.port = new Property_Port(property);
		}

		return port;
	}

	public function get_property(scope:Scope):Property {
		if (chain.length == 0) {
			var property_symbol:Property_Symbol = cast symbol;
			return property_symbol.get_property();
		}

		return chain[chain.length - 1];
		//var symbol.resolve(scope);
	}

	function create_chain_to_origin(scope:Scope):Property_Chain {
		if (chain.length > 0) {
			var property_symbol:Property_Symbol = cast symbol;
			var property = property_symbol.get_property();
			var full_chain:Property_Chain = cast [ property ].concat(chain);
			return full_chain.flip();
		}

		var _this = scope.definition._this;
		if (_this != null && _this.get_trellis() == symbol.get_parent_trellis())
			return [];

		throw new Exception("Not implemented");
		//var symbol.resolve(scope);
	}

}