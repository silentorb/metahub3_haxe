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
	public var dependencies = new Map<String, Trellis>();

	public function new(trellis:Trellis) {
		this.trellis = trellis;
		this.name = trellis.name;
		process();
	}

	public function process() {
		if (trellis.parent != null) {
			add_dependency(trellis.parent);
		}
		for (property in trellis.core_properties) {
			if (property.other_trellis != null) {
				add_dependency(property.other_trellis);
			}
		}
	}

	function add_dependency(trellis:Trellis) {
		dependencies[trellis.name] = trellis;
	}

}