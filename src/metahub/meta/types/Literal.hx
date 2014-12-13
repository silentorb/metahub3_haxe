package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Literal extends Expression {
	public var value:Dynamic;

	public function new(value:Dynamic) {
		this.value = value;
		type = Expression_Type.literal;
	}
}