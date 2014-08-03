package metahub.code;
import metahub.engine.Node;
import metahub.code.symbols.*;
import metahub.schema.Kind;
import metahub.schema.Namespace;

class Scope_Definition {
  var parent:Scope_Definition;
  var types = new Array<Symbol>();
  var symbols = new Map<String, Symbol>();
  public var depth:Int = 0;
	public var _this:This;
	public var hub:Hub;

  public function new(parent:Scope_Definition = null, hub:Hub = null) {
		this.parent = parent;
    if (parent != null) {
			this.hub = parent.hub;
      this.depth = parent.depth + 1;
			this._this = parent._this;
		}
		else {
			this.hub = hub;
		}
  }

  public function add_symbol(name:String, type:Type_Signature):Local_Symbol {
    var symbol = new Local_Symbol(type, this, this.types.length, name);
    this.types.push(symbol);
    this.symbols[name] = symbol;
    return symbol;
  }

  private function _find(name:String):Symbol {
    if (symbols.exists(name))
      return symbols[name];

    if (parent == null)
      return null;

    return parent._find(name);
  }

	public function find(name:String, namespace:Namespace):Symbol {
    if (symbols.exists(name))
      return symbols[name];

		var result = null;
    if (parent != null)
			result = parent._find(name);

		if (result == null) {
			if (_this != null) {
				return _this.get_context_symbol(name);
			}
		}

		if (result == null) {
			var trellis = hub.schema.get_trellis(name, namespace, false);
			if (trellis != null) {
				result = new Trellis_Symbol(trellis);
			}
		}

		if (result == null)
			throw new Exception("Could not find symbol: " + name + ".");

    return result;
  }

  public function get_symbol_by_name(name:String):Symbol {
    return this.symbols[name];
  }

  public function get_symbol_by_index(index:Int):Symbol {
    return this.types[index];
  }

  public function size():Int {
    return types.length;
  }
}