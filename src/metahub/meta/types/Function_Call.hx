package metahub.meta.types;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Call extends Expression {
	public var name:String;

	public function new(name:String) {
		type = Expression_Type.function_call;
		this.name = name;
	}

}