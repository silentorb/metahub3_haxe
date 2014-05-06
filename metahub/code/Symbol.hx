package code;

class Symbol {
  public var type:Type_Reference;
  public var scope_definition:Scope_Definition;
  public var index:Int;
  public var name:String;

  public function new(type:Type_Reference, scope_definition:Scope_Definition, index:Int, name:String) {
    this.type = type;
    this.scope_definition = scope_definition;
    this.index = index;
    this.name = name;
  }
}
