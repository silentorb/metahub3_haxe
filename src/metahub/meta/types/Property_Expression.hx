package metahub.meta.types;
import metahub.schema.Property;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Property_Expression extends Expression {
	public var property:Property;
	
	public function new(property:Property) 
	{
		type = Expression_Type.property;
		this.property = property;		
	}
	
}