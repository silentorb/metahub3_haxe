package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Constraint extends Expression
{
	public function new() {
		this.type = Expression_Type.constraint;
	}
}