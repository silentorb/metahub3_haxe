package metahub.meta.types;

/**
 * @author Christopher W. Johnson
 */

class Expression {
	public var type:Expression_Type;
	
	function new(type:Expression_Type) {
		this.type = type;
	}
	
	public function get_signature():metahub.logic.schema.Signature {
		throw Type.getClassName(Type.getClass(this)) + " does not implement get_signature().";
	}
}