package metahub.code.symbols;
import metahub.code.references.Property_Reference;
import metahub.code.references.Trellis_Reference;
import metahub.code.symbols.Symbol;
import metahub.engine.General_Port;
import metahub.schema.Property_Chain;
import metahub.schema.Trellis;
import metahub.code.references.Reference;

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

	public function get_port(scope:Scope, path:Property_Chain = null):General_Port {
    throw new Exception("Not supported");
  }

	public function get_type():Type_Reference {
		throw new Exception("Trellis_Symbol.get_type() is not implemented.");
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