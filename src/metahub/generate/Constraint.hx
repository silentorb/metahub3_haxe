package metahub.generate;
import metahub.code.expressions.Create_Constraint;
import metahub.code.expressions.Expression;
import metahub.code.expressions.Property_Reference;
import metahub.code.Type_Signature;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  public var type:Type_Signature;
  public var reference:Array<Tie>;
  public var expression:Expression;
	public var is_back_referencing = false;
	//public var children:Array<Expression>;
	public var operator:String;

	public function new(expression:Create_Constraint, railway:Railway) {
		type = expression.type;
		is_back_referencing = expression.is_back_referencing;
		operator = expression.operator;

		reference = convert_reference(expression.reference, railway);
		//this.expression = convert_reference(expression.expression, railway);
		this.expression = expression.expression;
	}

	static function convert_reference(expression:Expression, railway:Railway):Array<Tie> {
		var path:Array<Property_Reference> = cast expression.children;
		var result = [];
		var rail = railway.rails[path[0].property.trellis.name];
		for (token in path) {
			var tie = rail.all_ties[token.property.name];
			if (tie == null)
				throw new Exception("tie is null: " + token.property.fullname());
			result.push(tie);
			rail = tie.other_rail;
		}
		return result;
	}

}