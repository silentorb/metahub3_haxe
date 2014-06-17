package code;
import schema.*;

class Type_Reference {
  public var trellis:Trellis;
  public var type:Kind;

  public function new(type:Kind, trellis:Trellis = null) {
    this.type = type;
    this.trellis = trellis;
  }

  static function create_from_string(name:String):Type_Reference {
    var type_id:Kind = cast Reflect.field(Types, name);
    return new Type_Reference(type_id);
  }
}