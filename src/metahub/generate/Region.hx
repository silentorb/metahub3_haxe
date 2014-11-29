package metahub.generate;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Region
{
	public var namespace:Namespace;
	public var is_external = false;
	public var trellis_additional = new Map<String,Dynamic>();
	public var external_name:String = null;
	public function new(namespace:Namespace, target_name:String) 
	{
		this.namespace = namespace;
		is_external = namespace.is_external;
		
		if (namespace.additional == null)
			return;
			
		var additional = namespace.additional[target_name];
		if (additional == null)
			return;
		
		if (Reflect.hasField(additional, 'is_external'))
			is_external = Reflect.field(additional, 'is_external');

		if (Reflect.hasField(additional, 'namespace'))
			external_name = Reflect.field(additional, 'namespace');
		
		var trellises = Reflect.field(additional, 'trellises');
		if (trellises != null) {
			for (key in Reflect.fields(trellises)) {
				trellis_additional[key] = Reflect.field(trellises, key);
			}
		}
	}
}