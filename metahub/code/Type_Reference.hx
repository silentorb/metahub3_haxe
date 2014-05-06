package code;
import schema.Trellis;
import schema.Property;

class Type_Reference {
  public var trellis:Trellis;
  public var type:Property_Type;

  public function new(type:Property_Type, trellis:Trellis = null) {
    this.type = type;
    this.trellis = trellis;
  }

  static function create_from_string(name:String):Type_Reference {
    var type_id = Type.createEnum(Property_Type, name);
    return new Type_Reference(type_id);
  }
}