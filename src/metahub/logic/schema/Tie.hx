package metahub.logic.schema;
import metahub.imperative.types.Signature;
import metahub.meta.types.Expression;
import metahub.schema.Property;
import metahub.schema.Kind;
import metahub.logic.schema.Constraint;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Tie implements ITie {

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
	public var range:IRange = null;

	public var constraints = new Array<Constraint>();

	public function new(rail:Rail, property:Property) {
		this.rail = rail;
		this.type = property.type;
		this.property = property;
		tie_name = name = property.name;
	}

	public function initialize_links() {
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
		|| has_set_post_hook || (property.type == Kind.reference && !is_inherited());
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

	public function get_other_signature():Signature {
		if (other_rail == null)
			throw new Exception("get_other_signature() can only be called on lists or references.");

		var other_type = other_tie != null
		? other_tie.type
		: type == Kind.list ? Kind.reference : Kind.list;

		return {
			type: other_type,
			rail: other_rail,
			is_value: is_value
		};
	}

	public function is_inherited():Bool {
		return rail.parent != null && rail.parent.all_ties.exists(name);
	}
	
	public function finalize() {
		determine_range();
	}
		
	function determine_range() {
		if (type != Kind.float)
			return;
			
		var min:Constraint = null;
		var max:Constraint = null;

		for (constraint in constraints) {
			if (constraint.operator == ">" || constraint.operator == ">=") {
				min = constraint;
			}
			else if (constraint.operator == "<" || constraint.operator == "<=") {
				max = constraint;
			}			
		}
		
		if (min != null && max != null) {
			range = new Range_Float(get_expression_float(min.expression), get_expression_float(max.expression));
		}
	}
	
	static function get_expression_float(expression:Expression):Float{
		var conversion:metahub.imperative.types.Literal = cast expression;
		return conversion.value;
	}
	
	public function get_abstract_rail():IRail {
		return rail;
	}
	
	public function fullname():String {
		return rail.name + '.' + name;
	}
}