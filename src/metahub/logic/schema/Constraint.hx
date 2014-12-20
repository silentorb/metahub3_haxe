package metahub.logic.schema ;
import metahub.imperative.Imp;
import metahub.logic.schema.Railway;
import metahub.imperative.types.Expression_Type;
import metahub.imperative.types.Signature;
import metahub.meta.Scope;
import metahub.imperative.types.Expression;
import metahub.meta.types.Function_Call;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Constraint {
  public var signature:Signature;
  public var reference:Expression;
  public var expression:Expression;
	public var is_back_referencing = false;
	//public var children:Array<Expression>;
	public var operator:String;
	public var scope:Scope;

	public function new(expression:metahub.meta.types.Constraint, imp:Imp, scope:Scope) {
		//type = expression.type;
		//is_back_referencing = expression.is_back_referencing;
		operator = expression.operator;

		reference = imp.translate(expression.first);
		//this.expression = convert_reference(expression.expression, railway);
		this.expression = imp.translate(expression.second);
		this.scope = scope;
	}

}