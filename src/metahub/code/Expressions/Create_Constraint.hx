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
	public var children:Array<Expression>;

  public function new(reference:Expression, expression:Expression, is_back_referencing:Bool) {
    this.reference = reference;
    this.expression = expression;
		this.is_back_referencing = is_back_referencing;
		//children = [ reference, expression ];
		children = [];
  }

	public function to_port(scope:Scope, old_group:Group, signature_node:Type_Signature):General_Port {
		//var signature = Type_Network.analyze(expression, scope, reference.get_types()[0][0]);
		var type_unknown = new Type_Signature(Kind.unknown);
		var target = reference.to_port(scope, old_group, type_unknown);
		var assignment:Assignment_Node;
		var inside_back_reference = old_group.is_back_referencing;

		var group = new Group(old_group);
		group.is_back_referencing = is_back_referencing || inside_back_reference;
		var source = expression.to_port(scope, group, reference.get_type(type_unknown)[0]);
		//group.get_port(1).connect(target);
		//group.get_port(1).connect(source);

		if (is_back_referencing || scope.definition.is_particular_node || inside_back_reference) {
			assignment = new Assignment_Node(group, true);
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
		else {
			assignment = new Assignment_Node(group, false);
			group.get_port(1).connect(assignment.get_port(0));
		}

		assignment.get_port(1).connect(target);
		assignment.get_port(2).connect(source);

		scope.hub.constraints.push(group);

		target.connect(source);

		return group.get_port(0);
  }

	function process_self_modifying() {

	}

	public function get_type(out_type:Type_Signature = null):Array<Type_Signature> {
		return null;
	}

	public function to_string():String {
		return "Create_Constraint";
	}
}