package metahub.imperative.schema ;
import metahub.Hub;
import metahub.meta.types.Constraint;
import metahub.meta.types.Expression;
import metahub.meta.types.Expression_Type;
import metahub.meta.Scope;

import metahub.parser.Result;
import metahub.schema.Kind;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Railway {

	public var regions = new Map<String, Region>();
	public var target_name:String;

	public function new(hub:Hub, target_name:String) {
		this.target_name = target_name;

		for (namespace in hub.schema.root_namespace.children) {
			if (namespace.name == 'metahub')
				continue;

			var region = new Region(namespace, target_name);
			regions[namespace.name] = region;

			for (trellis in namespace.trellises) {
				region.rails[trellis.name] = new Rail(trellis, this);
			}
		}

		for (region in regions) {
			for (rail in region.rails) {
				rail.process1();
			}
		}
		
		for (region in regions) {
			for (rail in region.rails) {
				rail.process2();
			}
		}
	}

	public static function get_class_name(expression):String {
		return Type.getClassName(Type.getClass(expression)).split('.').pop();
	}

	public function get_rail(trellis:Trellis):Rail {
		return regions[trellis.namespace.name].rails[trellis.name];
	}
}