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

	public static function create_from_property(property:Property):Type_Signature {
		return new Type_Signature(property.type, property.other_trellis);
  }
}