package code.references;
import code.symbols.ISchema_Symbol;
import engine.IPort;
import schema.Property_Chain;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Trellis_Reference extends Reference<ISchema_Symbol>{

	public function new(symbol:ISchema_Symbol, chain:Property_Chain = null) {
		super(symbol, chain);
	}

	override public function get_port(scope:Scope):IPort {
		throw new Exception("Not implemented yet.");
	}

	override public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

}