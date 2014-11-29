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

	public var constraints = new Array<Constraint>();

	public function new(rail:Rail, property:Property) {
		this.rail = rail;
		this.property = property;
		tie_name = name = property.name;

		if (property.other_trellis != null) {
			trace('p', property.fullname(), property.other_trellis.name);
			other_rail = rail.railway.rails[property.other_trellis.name];
			if (other_rail != null && property.other_property != null && other_rail.all_ties.exists(property.other_property.name)) {
				other_tie = other_rail.all_ties[property.other_property.name];
				//other_tie.other_rail = rail;
				//other_tie.other_tie = this;
			}
		}
	}
}