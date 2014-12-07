package metahub.generate;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */

typedef Region_Additional = {
	?is_external:Bool,
	?namespace:String,
	?class_export:String
}
 
class Region
{
	public var namespace:Namespace;
	public var is_external = false;
	public var trellis_additional = new Map<String,Dynamic>();
	public var external_name:String = null;
	public var rails = new Map<String, Rail>();
	public var class_export:String = "";
	public var name:String;
	public var parent:Region = null;

	public function new(namespace:Namespace, target_name:String) 
	{
		this.namespace = namespace;
		name = namespace.name;
		is_external = namespace.is_external;
		
		if (namespace.additional == null)
			return;
			
		var additional:Region_Additional = namespace.additional[target_name];
		if (additional == null)
			return;
		
		if (Reflect.hasField(additional, 'is_external'))
			is_external = additional.is_external;

		if (Reflect.hasField(additional, 'namespace'))
			external_name = additional.namespace;

		if (Reflect.hasField(additional, 'class_export'))
			class_export = additional.class_export;
				
		var trellises = Reflect.field(additional, 'trellises');
		if (trellises != null) {
			for (key in Reflect.fields(trellises)) {
				trellis_additional[key] = Reflect.field(trellises, key);
			}
		}
	}
}