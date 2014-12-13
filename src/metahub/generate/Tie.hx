package metahub.generate;
import metahub.imperative.types.Signature;
import metahub.schema.Property;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Tie {

	public var rail:Rail;
	public var property:Property;
	public var name:String;
	public var tie_name:String;
	public var other_rail:Rail;
	public var other_tie:Tie;
	public var is_value = false;
	public var has_getter = false;
	public var has_set_post_hook = false;
	public var type:Kind;

	public var constraints = new Array<Constraint>();

	public function new(rail:Rail, property:Property) {
		this.rail = rail;
		this.type = property.type;
		this.property = property;
		tie_name = name = property.name;

		if (property.other_trellis != null) {
			other_rail = rail.railway.get_rail(property.other_trellis);
			is_value = property.other_trellis.is_value;
			if (other_rail != null && property.other_property != null && other_rail.all_ties.exists(property.other_property.name)) {
				other_tie = other_rail.all_ties[property.other_property.name];
				//other_tie.other_rail = rail;
				//other_tie.other_tie = this;
			}
		}

		var additional = rail.property_additional[name];
		if (additional != null && additional.hooks != null) {
			has_set_post_hook = additional.hooks.set_post != null;
		}
	}

	public function has_setter() {
		return (property.type != Kind.list && constraints.length > 0)
		|| has_set_post_hook;
	}

	public function get_setter_post_name() {
		return "set_" + name + "_post";
	}

	public function get_signature():Signature {
		return {
			type: property.type,
			rail: other_rail,
			is_value: is_value
		};
	}
}