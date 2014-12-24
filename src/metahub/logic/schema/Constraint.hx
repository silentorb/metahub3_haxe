package metahub.logic.schema ;
import metahub.imperative.Imp;
import metahub.logic.schema.Railway;
import metahub.meta.types.Expression;
import metahub.meta.types.Lambda;
//import metahub.logic.schema.Signature;
//import metahub.imperative.types.Expression;
import metahub.meta.types.Function_Call;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  public var reference:Expression;
  public var expression:Expression;
	public var is_back_referencing = false;
	public var operator:String;
	public var other_constraints = new Array<Constraint>();
	public var lambda:Lambda;
	//public var block:Array<Expression> = null;

	public function new(expression:metahub.meta.types.Constraint, imp:Imp) {
		operator = expression.operator;
		reference = expression.first;
		this.expression = expression.second;
		this.lambda = expression.lambda;
	}

}