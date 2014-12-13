package metahub.generate;
import metahub.Hub;
import metahub.meta.types.Block;
import metahub.meta.types.Expression;
import metahub.meta.types.Expression_Type;
import metahub.meta.Scope;
import metahub.meta.types.Scope_Expression;
import metahub.parser.Result;
import metahub.schema.Kind;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Railway {

	public var regions = new Map<String, Region>();
	public var target_name:String;

	public function new(hub:Hub, target_name:String) {
		this.target_name = target_name;

		for (namespace in hub.schema.root_namespace.children) {
			if (namespace.name == 'metahub')
				continue;

			var region = new Region(namespace, target_name);
			regions[namespace.name] = region;

			for (trellis in namespace.trellises) {
				region.rails[trellis.name] = new Rail(trellis, this);
			}
		}

		for (region in regions) {
			for (rail in region.rails) {
				rail.process();
			}
		}
	}

	public static function get_class_name(expression):String {
		return Type.getClassName(Type.getClass(expression)).split('.').pop();
	}

	public function generate_code() {
		for (region in regions) {
			for (rail in region.rails) {
				rail.generate_code();
			}
		}
	}

	public function process(expression:Expression, scope:Scope) {
		switch(Expression.type) {
			case Expression_Type.scope:
				scope_expression(cast expression, scope);

			case Expression_Type.block:
				block_expression(cast expression, scope);

			case Expression_Type.constraint:
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

	function constraint(expression:Constraint, scope:Scope) {
		var type = get_class_name(expression.reference);
		var reference:Array<Property_Reference> = cast expression.reference.children;
		//if (reference[0].property.other_trellis != null && reference[0].property.other_trellis.is_value) {
			//
		//}
		//else {
//
		//}
		var rail = get_rail(scope.definition.trellis);
		var tie = rail.all_ties[reference[0].property.name];
		tie.constraints.push(new Constraint(expression, rail.railway, scope));
		trace("reference:", type, tie.name);
	}

	public function get_rail(trellis:Trellis):Rail {
		return regions[trellis.namespace.name].rails[trellis.name];
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