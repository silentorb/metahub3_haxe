package metahub.meta.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Call extends Expression {
	public var name:String;
	public var input:Expression;

	public function new(name:String, input:Expression) {
		super(Expression_Type.function_call);
		this.name = name;
		this.input = input;
	}

}