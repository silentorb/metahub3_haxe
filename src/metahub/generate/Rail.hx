package metahub.generate;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

typedef Rail_Additional = {
	?name:String,
	?is_external:Bool,
	?source_file:String,
	?class_export:String
}
 
class Rail {

	public var trellis:Trellis;
	public var name:String;
	public var rail_name:String;
	public var dependencies = new Map<String, Dependency>();
	public var core_ties = new Map<String, Tie>();
	public var all_ties = new Map<String, Tie>();
	public var railway:Railway;
	public var parent:Rail;
	public var is_external = false;
	public var source_file:String = null;
	public var region:Region;
	public var hooks = new Map<String, Dynamic>();
	public var stubs = new Array<String>();
	public var property_additional = new Map<String, Property_Addition>();
	public var class_export:String = "";

	public function new(trellis:Trellis, railway:Railway) {
		this.trellis = trellis;
		this.railway = railway;
		rail_name = this.name = trellis.name;
		region = railway.regions[trellis.namespace.name];
		is_external = region.is_external;
		class_export = region.class_export;
		load_additional();
		if (!is_external && source_file == null)
			source_file = trellis.namespace.name + '/' + rail_name;
	}

	function load_additional() {
		if (!region.trellis_additional.exists(trellis.name))
			return;

		var map:Rail_Additional = region.trellis_additional[trellis.name];

		if (Reflect.hasField(map, 'is_external'))
			is_external = map.is_external;

		if (Reflect.hasField(map, 'name'))
			rail_name = map.name;

		if (Reflect.hasField(map, 'source_file'))
			source_file = map.source_file;

		if (Reflect.hasField(map, 'class_export'))
			class_export = map.class_export;
			
		if (Reflect.hasField(map, 'hooks')) {
			var hook_source = Reflect.field(map, 'hooks');
			for (key in Reflect.fields(hook_source)) {
				hooks[key] = Reflect.field(hook_source, key);
			}
		}

		if (Reflect.hasField(map, 'stubs')) {
			var hook_source = Reflect.field(map, 'stubs');
			for (key in Reflect.fields(hook_source)) {
				stubs.push(Reflect.field(hook_source, key));
			}
		}

		if (Reflect.hasField(map, 'properties')) {
			var properties = Reflect.field(map, 'properties');
			for (key in Reflect.fields(properties)) {
				property_additional[key] = Reflect.field(properties, key);
			}
		}
	}

	public function process() {
		if (trellis.parent != null) {
			parent = railway.get_rail(trellis.parent);
			add_dependency(parent).allow_ambient = false;
		}
		for (property in trellis.properties) {
			var tie = new Tie(this, property);
			all_ties[tie.name] = tie;
			if (property.trellis == trellis) {
				core_ties[tie.name] = tie;
				if (property.other_trellis != null) {
					var dependency = add_dependency(railway.get_rail(property.other_trellis));
					if (property.type == Kind.list)
						dependency.allow_ambient = false;
				}
			}
		}
	}

	function add_dependency(rail:Rail):Dependency {
		if (!dependencies.exists(rail.name))
			dependencies[rail.name] = new Dependency(rail);

		return dependencies[rail.name];
	}

}