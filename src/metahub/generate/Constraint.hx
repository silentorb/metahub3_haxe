package metahub.generate;
import metahub.code.expressions.Create_Constraint;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Function_Call;
import metahub.code.expressions.Property_Reference;
import metahub.code.Scope;
import metahub.code.Type_Signature;
import metahub.code.expressions.Token_Expression;
import metahub.imperative.Expression_Type;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  public var type:Type_Signature;
  public var reference:metahub.imperative.Expression;
  public var expression:Expression;
	public var is_back_referencing = false;
	//public var children:Array<Expression>;
	public var operator:String;
	public var scope:Scope;

	public function new(expression:Create_Constraint, railway:Railway, scope:Scope) {
		type = expression.type;
		is_back_referencing = expression.is_back_referencing;
		operator = expression.operator;

		reference = convert_reference(expression.reference, railway);
		//this.expression = convert_reference(expression.expression, railway);
		this.expression = expression.expression;
		this.scope = scope;
	}

	static function convert_reference(expression:Expression, railway:Railway):metahub.imperative.Expression {
		var path:Array<Token_Expression> = cast expression.children;
		var result = [];
		var first:Property_Reference = cast path[0];
		var rail = railway.get_rail(first.property.trellis);
		for (token in path) {
			if (Reflect.hasField(token, 'property')) {
				var property_token:Property_Reference = cast token;
				var tie = rail.all_ties[property_token.property.name];
				if (tie == null)
					throw new Exception("tie is null: " + property_token.property.fullname());

				result.push(new Car(tie, null));
				rail = tie.other_rail;
			}
			else {
				var function_token:Function_Call = cast token;
				result.push(new Car(null, function_token));
			}
		}
		return { type: Expression_Type.path, path: result };
	}

}