package engine;
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
  var ports = new Array<IPort>();
  public var id:Identity;
  var trellis:Trellis;
//  var dependencies = new Array<Dependency>();
//  var dependents = new Array<Dependency>();

  public function new(hub:Hub, id:Identity, trellis:Trellis) {
    this.hub = hub;
    this.id = id;
    this.trellis = trellis;

    for (property in trellis.properties) {
      values.push(property.get_default());
      var port = property.type == Property_Type.list
      ? new List_Port(this, property)
      : new Port(this, property, property.get_default());
      ports.push(port);
    }
  }

  public function get_inputs():Array<IPort> {
    var result = new Array<IPort>();
    for (property in trellis.properties) {
      if (property.name != "output") {
        result.push(get_port(property.id));
      }
    }

    return result;
  }

  public function get_port(index:Int):IPort {
#if debug
  if ((index < 0 && index >= ports.length) || ports[index] == null)
  throw new Exception("Node " + trellis.name + " does not have a property index of " + index + ".");
#end
    return ports[index];
  }

  public function get_port_by_name(name:String):IPort {
    var property = trellis.get_property(name);
    return get_port(property.id);
  }

  public function get_value(index:Int):Dynamic {
    var port:Port = cast get_port(index);
    return port.get_value();
  }

  public function get_value_by_name(name:String):Dynamic {
    var property = trellis.get_property(name);
    var port:Port = cast ports[property.id];
    return port.get_value();
  }

  public function set_value(index:Int, value:Dynamic) {
    var port:Port = cast ports[index];
    port.set_value(value);
  }

  public function add_list_value(index:Int, value:Dynamic) {
    var port:List_Port = cast ports[index];
    port.add_value(value);
  }
}