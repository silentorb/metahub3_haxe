package metahub.code;
import metahub.schema.*;

class Type_Signature {
  public var trellis:Trellis;
  public var type:Kind;

  public function new(type:Kind, trellis:Trellis = null) {
    this.type = type;
    this.trellis = trellis;
  }

  static function create_from_string(name:String):Type_Signature {
    var type_id:Kind = cast Reflect.field(Types, name);
    return new Type_Signature(type_id);
  }

	public static function from_property(property:Property):Type_Signature {
		return new Type_Signature(property.type, property.other_trellis);
  }
	
	public function equals(other:Type_Signature):Bool {
		if (this.type != other.type)
			return false;
			
		if (this.type == Kind.reference || this.type == Kind.list) {
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
			if (other.type != Kind.unknown)
				type = other.type;
		}
		
		if (type == Kind.list || type == Kind.reference) {
			if (trellis == null && other.trellis != null)
				trellis = other.trellis;
		}
	}
}