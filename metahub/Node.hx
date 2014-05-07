package;
import schema.Trellis;
import schema.Property;

typedef Identity = UInt;

interface INode {
  function get_value(index:Int):Dynamic;
  function set_value(index:Int, value:Dynamic):Void;
}

class Node implements INode {
  var hub:Hub;
  var values = new Array<Dynamic>();
  public var id:Identity;
  var trellis:Trellis;

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

    for (property in trellis.properties) {
      values.push(property.get_default());
    }
  }

  public function get_value(index:Int):Dynamic {
    return values[index];
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    return values[property.id];
  }

  public function set_value(index:Int, value:Dynamic) {
    values[index] = value;
  }
}