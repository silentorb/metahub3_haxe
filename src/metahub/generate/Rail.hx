package metahub.generate;
import metahub.schema.Trellis;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Rail {

	public var trellis:Trellis;
	public var name:String;
	public var rail_name:String;
	public var dependencies = new Map<String, Rail>();
	public var core_ties = new Map<String, Tie>();
	public var all_ties = new Map<String, Tie>();
	public var railway:Railway;
	public var parent:Rail;
	public var is_external = false;

	public function new(trellis:Trellis, railway:Railway, map:Dynamic) {
		this.trellis = trellis;
		this.railway = railway;
		rail_name = this.name = trellis.name;
		if (map != null) {
			if (Reflect.hasField(map, 'is_external'))
				is_external = Reflect.field(map, 'is_external');
				
			if (Reflect.hasField(map, 'name'))
				rail_name = Reflect.field(map, 'name');
		}
	}

	public function process() {
		if (trellis.parent != null) {
			parent = railway.rails[trellis.parent.name];
			add_dependency(parent);
		}
		for (property in trellis.properties) {
			var tie = new Tie(this, property);
			all_ties[tie.name] = tie;
			if (property.trellis == trellis) {
				core_ties[tie.name] = tie;
				if (property.other_trellis != null) {
					add_dependency(railway.rails[property.other_trellis.name]);
				}
			}
		}
	}

	function add_dependency(rail:Rail) {
		dependencies[rail.name] = rail;
	}

}