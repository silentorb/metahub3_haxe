package metahub.code;
import metahub.schema.*;

class Type_Signature {
  public var trellis:Trellis;
  public var type:Kind;
	public var is_numeric:Bool = false; // Only considered when type == unknown

  public function new(type:Kind, trellis:Trellis = null) {
    this.type = type;
    this.trellis = trellis;
		update_numeric();
  }

	function update_numeric() {
		if (type != unknown) // Only update if the type is known
			is_numeric = type == Kind.int || type == Kind.float || (type == Kind.reference && trellis != null && trellis.is_numeric);
	}

  //static function create_from_string(name:String):Type_Signature {
    //var type_id:Kind = cast Reflect.field(Types, name);
    //return new Type_Signature(type_id);
  //}

	public static function from_property(property:Property):Type_Signature {
		return new Type_Signature(property.type, property.other_trellis);
  }

	public function equals(other:Type_Signature):Bool {
		if (this.type != other.type) {
			return check_unknown(this, other) || check_unknown(other, this);
		}

		if (this.type == Kind.reference || this.type == Kind.list) {
			if (check_numeric(this, other) || check_numeric(other, this))
				return true;

			return this.trellis == other.trellis || this.trellis == null || other.trellis == null;
		}

		return true;
	}

	public function to_string() {
		if (trellis != null)
			return trellis.name;

		return Kind.to_string(type);
	}

	public function copy() {
		return new Type_Signature(type, trellis);
	}

	public static function copy_array(input:Array < Type_Signature > ) {
		var result = new Array<Type_Signature>();
		for (i in input) {
			result.push(i.copy());
		}
		return result;
	}

	public function resolve(other:Type_Signature) {
		if (type == Kind.unknown) {
			if (other.type != Kind.unknown) {
				type = other.type;
				update_numeric();
			}
		}
		else if (check_numeric(other, this)) {
			type = Kind.reference;
			is_numeric = true;
			trellis = other.trellis;
		}

		if (type == Kind.list || type == Kind.reference) {
			if (trellis == null && other.trellis != null)
				trellis = other.trellis;
		}
	}

	public static function array_from_trellis(trellis:Trellis) {
		var result = new Array<Type_Signature>();
		for (property in trellis.properties) {
			result.push(Type_Signature.from_property(property));
		}

		return result;
	}

	public static function check_numeric(first:Type_Signature, second:Type_Signature) {
		return first.type == Kind.reference
			&& first.trellis != null
			&& first.trellis.is_numeric
			&& second.type == Kind.reference
			&& (second.trellis == null || second.trellis == first.trellis);
	}

	public static function check_unknown(first:Type_Signature, second:Type_Signature) {
		if (first.type == Kind.unknown) {
			return first.is_numeric == second.is_numeric;
		}

		return false;
	}
}