package code;
import schema.Trellis;
import schema.Property;
import schema.Types;
import schema.Types;

class Type_Reference {
  public var trellis:Trellis;
  public var type:Types;

  public function new(type:Types, trellis:Trellis = null) {
    this.type = type;
    this.trellis = trellis;
  }

  static function create_from_string(name:String):Type_Reference {
    var type_id = Type.createEnum(Types, name);
    return new Type_Reference(type_id);
  }
}