package code.references;
import code.symbols.Property_Symbol;
import engine.IPort;
import schema.Property_Port;
import code.symbols.ISchema_Symbol;
import schema.Property;

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
		var port = new Property_Port(property);
		property.ports.push(port);
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

}