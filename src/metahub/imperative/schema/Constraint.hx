package metahub.imperative.schema ;
import metahub.imperative.schema.Railway;
import metahub.imperative.types.Expression_Type;
import metahub.imperative.types.Signature;
import metahub.meta.Scope;
import metahub.meta.types.Expression;
import metahub.meta.types.Function_Call;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  public var signature:Signature;
  public var reference:metahub.imperative.types.Expression;
  public var expression:Expression;
	public var is_back_referencing = false;
	//public var children:Array<Expression>;
	public var operator:String;
	public var scope:Scope;

	public function new(expression:metahub.meta.types.Constraint, railway:Railway, scope:Scope) {
		//type = expression.type;
		//is_back_referencing = expression.is_back_referencing;
		operator = expression.operator;

		reference = convert_reference(cast expression.first, railway);
		//this.expression = convert_reference(expression.expression, railway);
		this.expression = expression.second;
		this.scope = scope;
	}

	static function convert_reference(expression:Path, railway:Railway):metahub.imperative.types.Expression {
		//throw new Exception("Not yet implemented.");
		
		var path = expression.children;
		var result = new Array<metahub.imperative.types.Expression>();
		var first:Property_Expression = cast path[0];
		var rail = railway.get_rail(first.property.trellis);
		for (token in path) {
			if (token.type == metahub.meta.types.Expression_Type.property) {
				var property_token:Property_Expression = cast token;
				var tie = rail.all_ties[property_token.property.name];
				if (tie == null)
					throw new Exception("tie is null: " + property_token.property.fullname());

				result.push(new metahub.imperative.types.Property_Expression(tie));
				rail = tie.other_rail;
			}
			else {
				var function_token:Function_Call = cast token;
				result.push(new metahub.imperative.types.Function_Call(function_token.name, [], true));
			}
		}
		return new metahub.imperative.types.Path(result);
	}

	public function get_reference_property():Tie {
		var path:Path = cast reference;
		var property_expression:metahub.imperative.types.Property_Expression = cast path.children[0];
		return property_expression.tie;
	}
}