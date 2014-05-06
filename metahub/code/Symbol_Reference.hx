package code;

class Symbol_Reference {
  var scope_definition:Scope_Definition;
  var index:Int;

  public function new(scope_definition:Scope_Definition, index:Int) {
    this.scope_definition = scope_definition;
    this.index = index;
  }
}