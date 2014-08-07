package metahub.code;
import metahub.code.expressions.Expression;
import metahub.code.references.Property_Reference;
import metahub.code.references.Reference_Start;
import metahub.engine.Node;
import metahub.code.expressions.Expression_Utility;
import metahub.code.references.Reference;


class Assignment {
	var reference:Reference;
  var expression:Expression;

  public function new(reference:Reference, expression:Expression) {
    this.reference = reference;
    this.expression = expression;
  }

  public function apply(node:Node, scope:Scope) {
		var port = reference.to_port(scope);
		var input_type = reference.get_type();
		//var input_type = Type_Signature.from_property(node.trellis.properties[index]);
		port.set_node_value(Expression_Utility.resolve(expression, input_type, scope), null, null);
    //node.set_value(index, Expression_Utility.resolve(expression, input_type, scope));
  }

	//public function get_port(scope:Scope, start:Reference_Start) {
		//switch (start) {
			//case Reference_Start.trellis:
				//return scope.definition._this;
			//default:
//
		//}
	//}
}

class Setter {

  var assignments = new Array<Assignment>();

  public function add(reference:Reference, expression:Expression) {
    assignments.push(new Assignment(reference, expression));
  }

	public function run(node:Node, scope:Scope) {
		for (assignment in assignments) {
      assignment.apply(node, scope);
    }
	}
}