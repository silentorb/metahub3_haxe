package metahub.imperative.types ;
import metahub.imperative.schema.Rail;
import metahub.schema.Kind;

/**
 * @author Christopher W. Johnson
 */

class Function_Definition extends Expression {
	public var name:String;
	public var parameters:Array<Parameter>;
	public var block:Array<Expression>;
	public var return_type:Signature;
	public var rail:Rail;
	
	public function new(name:String, rail:Rail, parameters:Array<Parameter>,block:Array<Expression>,	return_type:Signature = null) {
		super(Expression_Type.function_definition);
		this.name = name;
		this.parameters = parameters;
		this.block = block;
		this.return_type = return_type == null
		? { type: Kind.none }
		: return_type;
		
		this.rail = rail;
		if (rail != null)
			rail.functions.push(this);
	}
}
