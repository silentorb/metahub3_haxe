package metahub.code.references;
import metahub.code.symbols.Local_Symbol;
import metahub.engine.General_Port;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Port_Reference extends Reference<Local_Symbol> {

	override public function resolve_port(scope:Scope):General_Port {
		throw new Exception("Not implemented yet.");
	}

	override public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}
}