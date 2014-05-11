package code.expressions;
import schema.Trellis;
import schema.Property;
import engine.IPort;

class Create_Node implements Expression {
  public var trellis:Trellis;
  public var assignments = new Map<Int, Expression>();
  public var type:Type_Reference;

  public function new(trellis:Trellis) {
    this.trellis = trellis;
    type = new Type_Reference(Property_Type.reference, trellis);
  }

  public function resolve(scope:Scope):Dynamic {
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