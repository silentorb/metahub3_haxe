package metahub.code.expressions;
import metahub.code.symbols.Local_Symbol;
import metahub.engine.Node;
import metahub.engine.IPort;

class Assignment {
  var index:Int;
  var expression:Expression;

  public function new(index:Int, expression:Expression) {
    this.index = index;
    this.expression = expression;
  }

  public function apply(node:Node, scope:Scope) {
    node.set_value(index, expression.resolve(scope));
  }
}

class Set implements Expression {
  public var type:Type_Reference;
  var reference:Local_Symbol;
  var assignments = new Array<Assignment>();

  public function new(reference:Local_Symbol) {
    this.reference = reference;
  }

  public function add_assignment(index:Int, expression:Expression) {
    assignments.push(new Assignment(index, expression));
  }

  public function resolve(scope:Scope):Dynamic {
    var node = reference.get_node(scope);
    for (assignment in assignments) {
      assignment.apply(node, scope);
    }

    return null;
  }

  public function to_port(scope:Scope):IPort {
    return null;
  }
}