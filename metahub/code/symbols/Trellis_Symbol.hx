package code.symbols;
import code.references.Property_Reference;
import code.references.Trellis_Reference;
import code.symbols.Symbol;
import engine.IPort;
import schema.Property_Chain;
import schema.Trellis;
import code.references.Reference;

class Trellis_Symbol implements ISchema_Symbol implements This  {
	var trellis:Trellis;
	var symbol:ISchema_Symbol;

	public function new(trellis:Trellis) {
		this.trellis = trellis;
	}

	public function get_trellis():Trellis {
		return trellis;
	}

  public function get_parent_trellis():Trellis {
    return trellis;
  }

	public function get_port(scope:Scope, path:Property_Chain = null):IPort {
    throw new Exception("Not supported");
  }

  public function resolve(scope:Scope):Dynamic {
		return null;
	}

	public function get_context_symbol(name:String):Symbol {
		var property = trellis.get_property(name);
		if (property == null)
			return null;

		return new Property_Symbol(property);
	}

	public function get_layer() {
		return Layer.schema;
	}

	public function create_reference(path:Array<String>):Reference<ISchema_Symbol> {
		var trellis = symbol.get_trellis();
		var chain = Property_Chain_Helper.from_string(path, trellis);
		var last_property = chain[chain.length - 1];
		if (last_property.other_trellis == null)
			return new Trellis_Reference(symbol, chain);

		return new Property_Reference(symbol, chain);
	}
}