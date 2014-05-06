package code;

class Expression_Reference implements Expression {
  public var reference:Symbol;
  public var type:Type_Reference;

  public function new(reference:Symbol) {
    this.reference = reference;
  }

  public function resolve(scope:Scope):Dynamic {
    return scope.resolve_symbol(reference);
  }
}