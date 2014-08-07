package metahub.code.references;
import metahub.code.Path;
import metahub.code.symbols.Property_Symbol;
import metahub.engine.General_Port;
import metahub.schema.Property_Port;
import metahub.code.nodes.Context_Converter;
import metahub.code.symbols.ISchema_Symbol;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.schema.Kind;


/**
 * ...
 * @author Christopher W. Johnson
 */
/*
class Property_Reference {
  public var chain:Path;

	public function resolve(scope:Scope):Dynamic {
		throw new Exception("Not implemented yet.");
	}

	public function get_property(scope:Scope):Property {
		if (chain.length == 0) {
			var property_symbol:Property_Symbol = cast symbol;
			return property_symbol.get_property();
		}

		return chain[chain.length - 1];
		//var symbol.resolve(scope);
	}

	//function create_chain_to_origin(scope:Scope):Property_Chain {
		//if (chain.length > 0) {
			//var property_symbol:Property_Symbol = cast symbol;
			//var property = property_symbol.get_property();
			//var full_chain:Property_Chain = cast [ property ].concat(chain);
			//return full_chain.flip();
		//}
//
		//var _this = scope.definition._this;
		//if (_this != null && _this.get_trellis() == symbol.get_parent_trellis())
			//return [];
//
		//throw new Exception("Not implemented");
		////var symbol.resolve(scope);
	//}

	public function resolve_port(scope:Scope):General_Port {
		var property = get_property(scope);
		return property.trellis.get_port(property.id);
	}

	public function create_converter(scope:Scope):Context_Converter {
		var property_symbol:Property_Symbol = cast symbol;
		var prop = property_symbol.get_property();
		var scope_trellis = scope.definition._this.get_trellis();
		if (prop.trellis.id == scope_trellis.id && prop.type == Kind.list)
			return null;

		//var prop = get_property(scope);
    if (prop.other_property == null)
      return null;

		return new Context_Converter(prop, prop.other_property);
	}
}*/