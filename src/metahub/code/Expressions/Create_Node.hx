package metahub.code.expressions;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.engine.IPort;
import metahub.schema.Kind;

class Create_Node implements Expression {
  public var trellis:Trellis;
  public var assignments = new Map<Int, Expression>();
  public var type:Type_Reference;

  public function new(trellis:Trellis) {
    this.trellis = trellis;
    type = new Type_Reference(Kind.reference, trellis);
  }

  public function resolve(scope:Scope):Dynamic {
		trace('create node', trellis.name);
    var node = scope.hub.create_node(trellis);
    for (i in assignments.keys()) {
      var expression = assignments[i];
      node.set_value(i, expression.resolve(scope));
    }

    return node.id;
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}