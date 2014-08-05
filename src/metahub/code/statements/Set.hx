package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Expression_Utility;
import metahub.code.Node_Signature;
import metahub.code.symbols.Local_Symbol;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.engine.General_Port;

class Assignment {
  var index:Int;
  var expression:Expression;

  public function new(index:Int, expression:Expression) {
    this.index = index;
    this.expression = expression;
  }

  public function apply(node:Node, scope:Scope) {
		//throw new Exception("Assignment.apply is not implemented.");
		var input_type = Type_Signature.from_property(node.trellis.properties[index]);
    node.set_value(index, Expression_Utility.resolve(expression, input_type, scope));
  }
}

class Set implements Statement {
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

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_type():Type_Signature {
		return reference.get_type();
	}
}