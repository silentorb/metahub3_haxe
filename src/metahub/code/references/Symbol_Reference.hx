package metahub.code.references;
import metahub.code.Path;
import metahub.code.symbols.Local_Symbol;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Symbol_Reference{

	public var symbol:Local_Symbol;
	public var path:Path;

	public function new(symbol:Local_Symbol, path:Path) {
		this.symbol = symbol;
		this.path = path;
	}

}