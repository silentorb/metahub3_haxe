package code;

class Scope_Definition {
  var parent:Scope_Definition;
  var types = new Array<Symbol>();
  var symbols = new Map<String, Symbol>();
  public var depth:Int = 0;

  public function new(parent:Scope_Definition = null) {
    this.parent = parent;
    if (parent != null)
      this.depth = parent.depth + 1;
  }

  public function add_symbol(name:String, type:Type_Reference):Symbol {
    var symbol = new Symbol(type, this, this.types.length, name);
    this.types.push(symbol);
    this.symbols[name] = symbol;
    return symbol;
  }

  public function find(name:String):Symbol {
    if (symbols.exists(name))
      return symbols[name];

    if (parent == null)
      throw new Exception("Could not find symbol: " + name + ".");

    return parent.find(name);
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