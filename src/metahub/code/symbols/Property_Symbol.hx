package metahub.code.symbols;
import metahub.code.expressions.Trellis_Scope;
import metahub.code.references.*;
import metahub.engine.IPort;
import metahub.schema.*;
import metahub.schema.Property_Chain;

class Property_Symbol implements ISchema_Symbol {

	var property:Property;

	public function new(property:Property) {
		this.property = property;
	}

	public function get_port(scope:Scope, path:Property_Chain = null):IPort {
    throw new Exception("Not supported");
		//return property;
  }

	public function resolve(scope:Scope):Dynamic {
		return null;
	}

	public function get_layer() {
		return Layer.schema;
	}

	public function get_trellis():Trellis {
		return property.other_trellis;
	}

  public function get_parent_trellis():Trellis {
    return property.trellis;
  }

	public function get_property():Property {
		return property;
	}

	public function create_reference(path:Array<String>):Reference<ISchema_Symbol> {
		var trellis = get_trellis();
		var chain = Property_Chain_Helper.from_string(path, trellis);
		if (chain.length == 0) {
			if (property.type == Kind.reference)
				return new Trellis_Reference(this, chain);

			return new Property_Reference(this, chain);
		}
		else {
			var last_property = chain[chain.length - 1];
			if (last_property.other_trellis == null)
				return new Property_Reference(this, chain);

			return new Trellis_Reference(this, chain);
		}

	}
}