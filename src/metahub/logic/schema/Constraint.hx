package metahub.logic.schema ;
import metahub.imperative.Imp;
import metahub.logic.schema.Railway;
import metahub.meta.types.Expression;
//import metahub.imperative.types.Signature;
//import metahub.imperative.types.Expression;
import metahub.meta.types.Function_Call;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  //public var signature:Signature;
  public var reference:Expression;
  public var expression:Expression;
	public var is_back_referencing = false;
	//public var children:Array<Expression>;
	public var operator:String;
	public var other_constraints = new Array<Constraint>();

	public function new(expression:metahub.meta.types.Constraint, imp:Imp) {
		//type = expression.type;
		//is_back_referencing = expression.is_back_referencing;
		operator = expression.operator;

		reference = expression.first;
		//this.expression = convert_reference(expression.expression, railway);
		this.expression = expression.second;
	}

}