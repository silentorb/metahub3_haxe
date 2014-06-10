package code.references;
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

	public function get_port(scope:Scope):IPort {
		var property = get_property(scope);
		return new Property_Port(property);
	}

	public function get_property(scope:Scope):Property {
		throw new Exception("Not implemented.");
		//var symbol.resolve(scope);
	}

}