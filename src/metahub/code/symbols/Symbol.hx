package metahub.code.symbols;
import metahub.code.Layer;
import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.schema.Trellis;


interface Symbol {
	function resolve(scope:Scope):Dynamic;
	function get_trellis():Trellis;
	function get_layer():Layer;
	function get_type():Type_Signature;
}
