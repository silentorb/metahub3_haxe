package metahub.code.symbols;
import metahub.code.Layer;
import metahub.engine.IPort;
import metahub.schema.Property_Chain;
import metahub.schema.Trellis;

interface Symbol {
	//var symbol_type:Symbol_Type;
function resolve(scope:Scope):Dynamic;
function get_trellis():Trellis;
function get_layer():Layer;
//function get_port(scope:Scope, path:Property_Chain = null):IPort;
}
