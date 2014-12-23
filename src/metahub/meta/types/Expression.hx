package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Expression {
	public var type:Expression_Type;
	
	function new(type:Expression_Type) {
		this.type = type;
	}
}