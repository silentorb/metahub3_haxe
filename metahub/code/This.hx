package code;
import code.symbols.Symbol;

interface This {
	function get_context_symbol(name:String):Symbol;
	function get_layer():Layer;
}