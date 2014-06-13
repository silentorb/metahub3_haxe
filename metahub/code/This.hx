package code;
import code.symbols.Symbol;
import schema.Trellis;

interface This {
	function get_context_symbol(name:String):Symbol;
	function get_layer():Layer;
	function get_trellis():Trellis;

}