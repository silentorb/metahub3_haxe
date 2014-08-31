package metahub.code.expressions ;

import metahub.code.expressions.Expression;
import metahub.code.nodes.Assignment_Node;
import metahub.code.nodes.Block_Node;
import metahub.code.nodes.Group;
import metahub.code.Reference;
import metahub.code.Type_Signature;
import metahub.engine.Constraint_Operator;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Constraint implements Expression {
  public var type:Type_Signature;
  var reference:Expression;
  var expression:Expression;
	var is_back_referencing = false;

  public function new(reference:Expression, expression:Expression, is_back_referencing:Bool) {
    this.reference = reference;
    this.expression = expression;
		this.is_back_referencing = is_back_referencing;
  }

	public function to_port(scope:Scope, old_group:Group, signature_node:Node_Signature):General_Port {
		var target = reference.to_port(scope, old_group, signature_node.children[0]);

		var inside_back_reference = old_group.is_back_referencing;

		//var signature = Type_Network.analyze(expression, reference.get_type(), scope);
		var group = new Group(old_group);
		group.is_back_referencing = is_back_referencing || inside_back_reference;
		var source = expression.to_port(scope, group, signature_node.children[1]);
		group.get_port(1).connect(target);
		group.get_port(1).connect(source);

		if (is_back_referencing || scope.definition.is_particular_node || inside_back_reference) {
			var assignment = new Assignment_Node(group);
			assignment.get_port(1).connect(target);
			assignment.get_port(2).connect(source);

			if (scope.definition.is_particular_node || inside_back_reference) {
				return assignment.get_port(0);
			}
			var block = new Block_Node(scope, group);
			block.get_port(1).connect(assignment.get_port(0));
			scope.hub.connect_to_increment(block.get_port(0));
			return block.get_port(0);
		}

		scope.hub.constraints.push(group);

		target.connect(source);
		
		return group.get_port(0);
  }

	public function get_types():Array < Array < Type_Signature >> {

		return [ [ new Type_Signature(Kind.none), new Type_Signature(Kind.unknown), new Type_Signature(Kind.unknown) ] ];
	}

	public function to_string():String {
		return reference.to_string();
	}

	public function get_children():Array<Expression> {
		return [ reference, expression ];
	}
}