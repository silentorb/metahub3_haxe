package metahub.logic.schema;
import metahub.logic.schema.Signature;
import metahub.meta.types.Expression;
import metahub.schema.Property;
import metahub.schema.Kind;
import metahub.logic.schema.Constraint;
import metahub.imperative.code.Parse;

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
	public var ranges = new Array<IRange>();

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
		//if (type != Kind.float)
			//return;
		if (type == Kind.list)
			return;

		var pairs = new Map<String, { min:{expression:Expression}, max:{expression:Expression}, path:Array<Tie> }>();
		//var min:Constraint = null;
		//var max:Constraint = null;

		for (constraint in constraints) {
			var path = Parse.get_path(constraint.reference);
			path.shift();
			var path_name = path.map(function(t) return t.name).join(".");
			if (!pairs.exists(path_name)) {
				pairs[path_name] = {
					min: null,
					max: null,
					path: path
				};
			}

			if (constraint.operator == "in") {
				var args:metahub.meta.types.Block = cast constraint.expression;
				pairs[path_name].min = { expression: args.children[0] };
				pairs[path_name].max = { expression: args.children[1] };
			}
			else if (constraint.operator == ">" || constraint.operator == ">=") {
				pairs[path_name].min = constraint;
			}
			else if (constraint.operator == "<" || constraint.operator == "<=") {
				pairs[path_name].max = constraint;
			}
		}

		for (pair in pairs) {
			if (pair.min != null && pair.max != null) {
				//trace('range', fullname());
				ranges.push(new Range_Float(
					get_expression_float(pair.min.expression),
					get_expression_float(pair.max.expression), pair.path));
			}
		}
	}

	static function get_expression_float(expression:Expression):Float{
		var conversion:metahub.imperative.types.Literal = cast expression;
		return conversion.value;
	}

	public function get_abstract_rail():Rail {
		return rail;
	}

	public function fullname():String {
		return rail.name + '.' + name;
	}

	public function get_default_value():Dynamic {
		if (other_rail != null && other_rail.default_value != null)
			return other_rail.default_value;

		return property.get_default();
	}
}