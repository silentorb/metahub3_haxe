package metahub.generate;
import metahub.schema.Property;
import metahub.schema.Kind;
import metahub.code.expressions.Create_Constraint;

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
	public var has_setter = false;
	public var has_getter = false;
	public var has_set_post_hook = false;

	public var constraints = new Array<Constraint>();

	public function new(rail:Rail, property:Property) {
		this.rail = rail;
		this.property = property;
		tie_name = name = property.name;

		if (property.other_trellis != null) {
			trace('p', property.fullname(), property.other_trellis.name);
			other_rail = rail.railway.rails[property.other_trellis.name];
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
		
		has_setter = constraints.length > 0 || has_set_post_hook;
	}
	
	public function get_setter_post_name() {
		return "set_" + name + "_post";
	}
	
}