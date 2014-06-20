package metahub.code;
import metahub.code.symbols.Symbol;
import metahub.schema.Trellis;

interface This {
	function get_context_symbol(name:String):Symbol;
	function get_layer():Layer;
	function get_trellis():Trellis;

}