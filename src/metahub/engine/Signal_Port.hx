package metahub.engine;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Signal_Port implements IPort{
  public var connections = new Array<IPort>();
	public var on_change = new Array<Signal_Port->Dynamic->Context->Void>();
	public var multiple:Bool;
	public var kind:Kind;

  public function new(kind:Kind, multiple:Bool = false ) {
		this.kind = kind;
		this.multiple = multiple;
  }

  public function connect(other:IPort) {
    this.connections.push(other);
    other.connections.push(this);
  }

  public function get_value(context:Context):Dynamic {
    return multiple
			? connections.map(function(d) { return d.get_value(context); } )
			:	connections[0].get_value(context);
  }

  public function set_value(new_value:Dynamic, context:Context):Dynamic {
		if (on_change != null && on_change.length > 0) {
			for (action in on_change) {
				action(this, new_value, context);
			}
		}

		return new_value;
  }

	public function output(new_value:Dynamic, context:Context) {
		for (connection in connections) {
			new_value = connection.set_value(new_value, context);
		}
	}

	public function get_type():Kind {
		return kind;
	}
}