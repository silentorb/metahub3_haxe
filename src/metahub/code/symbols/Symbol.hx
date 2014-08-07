package metahub.code.symbols;
import metahub.code.Layer;
import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.schema.Trellis;


interface Symbol {
	//var symbol_type:Symbol_Type;
function resolve(scope:Scope):Dynamic;
function get_trellis():Trellis;
function get_layer():Layer;
function get_type():Type_Signature;
//function get_port(scope:Scope, path:Property_Chain = null):Port;
}
