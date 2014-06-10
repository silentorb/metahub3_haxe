package code.symbols;
import engine.IPort;
import schema.Property_Chain;
import schema.Trellis;

interface Symbol {
	//var symbol_type:Symbol_Type;
function resolve(scope:Scope):Dynamic;
function get_trellis():Trellis;
//function get_port(scope:Scope, path:Property_Chain = null):IPort;
}
