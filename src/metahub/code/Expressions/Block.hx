package metahub.code.expressions;
import metahub.schema.Property;
import metahub.engine.IPort;
import metahub.schema.Kind;

class Block implements Expression {

  public var expressions:Array<Expression> = new Array<Expression>();
  public var type:Type_Reference = new Type_Reference(Kind.any);
  var scope_definition:Scope_Definition;

  public function new(scope_definition:Scope_Definition) {
    this.scope_definition = scope_definition;
  }

  public function resolve(scope:Scope):Dynamic {
    var scope = new Scope(scope.hub, scope_definition, scope);

    for (e in expressions) {
      e.resolve(scope);
    }
    return null;
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}