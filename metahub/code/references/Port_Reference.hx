package code.references;
import code.symbols.Local_Symbol;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Port_Reference extends Reference<Local_Symbol> {
	override public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}
}