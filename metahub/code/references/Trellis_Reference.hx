package code.references;
import code.symbols.ISchema_Symbol;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Trellis_Reference extends Reference<ISchema_Symbol>{

	override public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

}