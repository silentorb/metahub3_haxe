package metahub.generate;
import metahub.code.expressions.*;
import metahub.code.Scope;
import metahub.code.Type_Signature;
import metahub.Hub;
import metahub.parser.Result;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Railway {

	public var rails = new Map<String, Rail>();

	public function new(hub:Hub) {
		for (trellis in hub.schema.trellises) {
			rails[trellis.name] = new Rail(trellis, this);
		}

		for (rail in rails) {
			rail.process();
		}
	}

	static function get_class_name(expression):String {
		return Type.getClassName(Type.getClass(expression)).split('.').pop();
	}

	public function process(expression:Expression, scope:Scope) {
		var type = get_class_name(expression);
		trace("expression:", type);

		switch(type) {
			case "Scope_Expression":
				scope_expression(cast expression, scope);

			case "Block":
				block_expression(cast expression, scope);

			case "Create_Constraint":
				constraint(cast expression, scope);
		}
	}

	function scope_expression(expression:Scope_Expression, scope:Scope) {
		var new_scope = new Scope(scope.hub, expression.scope_definition, scope);
		for (child in expression.children) {
			process(child, new_scope);
		}
	}

	function block_expression(expression:Block, scope:Scope) {
		for (child in expression.children) {
			process(child, scope);
		}
	}

	function constraint(expression:Create_Constraint, scope:Scope) {
		var type = get_class_name(expression.reference);
		var reference:Array<Property_Reference> = cast expression.reference.children;
		//if (reference[0].property.other_trellis != null && reference[0].property.other_trellis.is_value) {
			//
		//}
		//else {
//
		//}
		var rail = rails[scope.definition.trellis.name];
		var tie = rail.all_ties[reference[0].property.name];
		tie.constraints.push(new Constraint(expression, rail.railway));
		trace("reference:", type);
	}

	//function get_reference(reference:Expression) {
		//var children = reference.children;
		//var type_unknown = new Type_Signature(Kind.unknown);
//
		//var token_port = result.get_port(1);
		//var previous:Type_Signature = type_unknown.copy();
		//var port:General_Port = null;
//
		//for (i in 0...children.length) {
			//if (i > 0) {
				//previous = children[i - 1].get_type(previous)[0].copy();
			//}
//
			//var expression:Token_Expression = cast children[i];
			//var signature = [ type_unknown.copy(), previous ];
			//port = expression.to_token_port(scope, group, signature, i == children.length - 1, port);
			//token_port.connect(port);
		//}
		//return result.get_port(0);
	//}
}