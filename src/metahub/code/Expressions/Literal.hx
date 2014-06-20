package metahub.code.expressions;
import metahub.engine.IPort;
import metahub.engine.Port;
import metahub.schema.Kind;
import metahub.schema.Types;

class Literal implements Expression {
  var value:Dynamic;
  public var type:Type_Reference;

  public function new(value:Dynamic, type:Type_Reference) {
    this.value = value;
    this.type = type;
  }

  public function resolve(scope:Scope):Dynamic {
    return value;
  }

  public function to_port(scope:Scope):IPort {
		//var trellis = type.trellis;
		var trellis = scope.hub.schema.get_trellis(get_type_string(type.type));
    //var trellis = scope.hub.schema.get_trellis(Std.string(type.type));
    var node = scope.hub.create_node(trellis);
    var port:Port = cast node.get_port(0);
    port.set_value(value);
    return port;
  }

	static function get_type_string(id:Kind) {
		var fields = Reflect.fields(Types);
		var index:Int = cast id;
		return fields[index + 1];
	}
}