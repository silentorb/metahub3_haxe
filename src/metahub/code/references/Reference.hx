package metahub.code.references;
import metahub.code.nodes.Context_Converter;
import metahub.code.Layer;
import metahub.schema.Trellis;
import metahub.schema.Kind;

import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.code.symbols.*;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Reference {

	public var symbol:Symbol = null;
	public var trellis:Trellis = null;
	public var path:Path = null;

	public function new() {
	}

	public function get_type():Type_Signature {
		if (path.length == 0) {
			if (symbol == null)
				throw new Exception("Invalid reference; cannot find type.");

			return symbol.get_type();
		}

		return path.last().get_signature();
	}

	public function to_port(scope:Scope):General_Port {
		if (symbol != null) {
			throw new Exception("Not supported.");
		}
		else {
			var property = path.last();
			var port = property.trellis.get_port(property.id);

			if (property.type != Kind.pulse && (path.length >= 3 || (path.length == 2 && !property.trellis.is_value))) {
				var converter = new Context_Converter(path, scope.definition.trellis);
				port.connect(converter.get_port(1));
				return converter.get_port(0);
			}
			else {
				return port;
			}
		}
	}

	public function resolve(scope:Scope):Dynamic {
		if (symbol != null) {
			return symbol.resolve(scope);
		}
		else if (scope.node != null) {
			return path.resolve(scope.node);
		}
		//else if (scope.definition.trellis != null) {
			//var trellis = scope.definition.trellis;
//
		//}

		throw new Exception("Not supported.");
	}

	public static function from_scope(source:Array<String>, scope_definition:Scope_Definition) {
		var result = new Reference();
		var symbol = scope_definition.find(source[0]);
		if (symbol != null) {
			result.symbol = symbol;
			result.path = Path.from_array(source.slice(1), symbol.get_trellis());
		}
		else if (scope_definition.trellis != null) {
			result.path = Path.from_array(source, scope_definition.trellis);
		}
		else {
			throw new Exception("Cannot parse reference.");
		}

		return result;
	}
}
