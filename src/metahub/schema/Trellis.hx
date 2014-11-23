package metahub.schema;
import metahub.code.Change;
import metahub.code.nodes.Group;
import metahub.engine.Context;
import metahub.code.nodes.INode;
import metahub.engine.General_Port;
import metahub.engine.Node.Identity;
import metahub.schema.Property;

typedef ITrellis_Source = {
  name:String,
  //properties:Map<String, IProperty_Source>,
  properties:Dynamic,
  parent:String,
	?primary_key:String,
	?is_value:Bool
}

class Trellis implements INode {
  public var name:String;
  public var schema:Schema;
  var core_properties:Array<Property> = new Array<Property>();
  var all_properties:Array<Property>;
	public var parent:Trellis;
  public var id:Identity;
	public var identity_property:Property;
	public var namespace:Namespace;
  var property_keys:Map<String, Property> = new Map<String, Property>();
	var ports = new Array<General_Port>();
	public var readonly_ports = new Array<General_Port>();
	public var on_create_ports = new Array<General_Port>();
	public var properties = new Array<Property>();
	public var is_value:Bool = false;
	public var events:Array<String>;
	public var is_numeric:Bool = false;
	var _tree:Array<Trellis> = null;
	public var group = new Group(null);

  public function new(name:String, schema:Schema, namespace:Namespace) {
    this.name = name;
    this.schema = schema;
		this.namespace = namespace;
    namespace.trellises[name] = this;
  }

  public function add_property(name:String, source:IProperty_Source):Property {
    var property = new Property(name, source, this);
    this.property_keys[name] = property;
    property.id = 10000;
    core_properties.push(property);
    return property;
  }

	public function copy_identity(source:Dynamic, target:Dynamic) {
		var identity_key = identity_property.name;
		Reflect.setField(target, identity_key, Reflect.field(source, identity_key));
	}

  public function get_all_properties() {
		return property_keys;
    //var result = new Map<String, Property>();
    //var tree = this.get_tree();
		//var index = 0;
    //for (trellis in tree) {
      //for (property in trellis.core_properties) {
        //result[property.name] = property;
				//property.id = index++;
      //}
    //}
    //return result;
  }

	public function get_identity(seed:Dynamic) {
		if (identity_property == null)
			throw new Exception("This trellis does not have an identity property set.");

		return Reflect.field(seed, identity_property.name);
	}

  public function get_property(name:String):Property {
    return property_keys[name];
  }

	public function get_property_or_error(name:String):Property {
    var properties = this.get_all_properties();
    if (!properties.exists(name))
      throw new Exception(this.name + ' does not contain a property named ' + name + '.');

    return properties[name];
  }

	public function get_property_or_null(name:String):Property {
    var properties = this.get_all_properties();
    if (!properties.exists(name))
      return null;

    return properties[name];
  }

  public function get_value(index:Int, context:Context):Change {
		return new Change(context.node.get_value(index));
	}

  public function set_value(index:Int, change:Change, context:Context, source:General_Port = null) {
		if (!context.node.trellis.is_a(this))
			throw new Exception("Type mismatch: a " + context.node.trellis.name + " node was passed to trellis " + name + ".");

		context.node.set_value(index, change.value, source);
	}

	 public function set_external_value(index:Int, value:Dynamic, context:Context, source:General_Port) {
		#if trace
			context.hub.history.start_anchor();
		#end
		
		var port = ports[index];
		for (connection in port.connections) {
			if (connection == source)
				continue;

			#if trace
				context.hub.history.back_to_anchor();
			#end
			
			connection.set_node_value(new Change(value), context, port);
		}
		
		#if trace
			context.hub.history.end_anchor();
		#end
	}

	public function get_external_value(index:Int, change:Change, context:Context) {
		var port = ports[index];
		if (port.connections.length == 0)
			return null;

		if (port.connections.length > 1)
			throw new Exception("Not yet supported.");

		return port.connections[0].get_node_value(context);
	}

  public function get_tree():Array<Trellis> {
		if (_tree == null) {
			var trellis = this;
			_tree = new Array<Trellis>();

			do {
				_tree.unshift(trellis);
				trellis = trellis.parent;
			}
			while (trellis != null);
		}

    return _tree;
  }

  public function is_a(trellis:Trellis):Bool {
    var current = this;

    do {
      if (current == trellis)
        return true;

      current = current.parent;
    }
    while (current != null);

    return false;
  }

  public function load_properties(source:ITrellis_Source) {
    for (name in Reflect.fields(source.properties)) {
      add_property(name, Reflect.field(source.properties, name));
    }
  }

  public function initialize1(source:ITrellis_Source, namespace:Namespace) {
    var trellises = this.schema.trellises;
    if (source.parent != null) {
      var trellis = this.schema.get_trellis(source.parent, namespace);
      this.set_parent(trellis);
    }
		if (source.primary_key != null) {
			var primary_key = source.primary_key;
			if (property_keys.exists(primary_key)) {
				identity_property = property_keys[primary_key];
			}
		}
		else {
			if (parent != null) {
				identity_property = parent.identity_property;
			}
			else if (property_keys.exists("id")) {
				identity_property = property_keys["id"];
			}
		}

		var tree = this.get_tree();
		var index = 0;
    for (trellis in tree) {
      for (property in trellis.core_properties) {
				property.id = index++;
        properties.push(property);
				property_keys[property.name] = property;
				ports.push(new General_Port(this, ports.length));
				readonly_ports.push(new General_Port(this, readonly_ports.length));
			}
    }

		for (j in Reflect.fields(source.properties)) {
			var property:Property = this.get_property(j);
			property.initialize_link1(Reflect.field(source.properties, j));
		}
  }

	public function initialize2(source:ITrellis_Source) {
		if (Reflect.hasField(source, 'is_value'))
			is_value = source.is_value;
		else if (parent != null) {
			is_value = parent.is_value;
		}

    if (source.properties != null) {
			 for (j in Reflect.fields(source.properties)) {
        var property:Property = this.get_property(j);
        property.initialize_link2(Reflect.field(source.properties, j));
      }
    }

		//get_all_properties();

		is_numeric = true;
		for (p in properties) {
			if (p.type != Kind.float && p.type != Kind.int) {
				is_numeric = false;
				break;
			}
		}
	}

  function set_parent(parent:Trellis) {
    this.parent = parent;

//    if (!parent.identity)
//      throw new Exception(new Error(parent.name + ' needs a primary key when being inherited by ' + this.name + '.'));
//
//    this.identity = parent.identity.map((x) => x.clone(this))
  }

	public function get_port(index:Int):General_Port {
		return ports[index];
	}

	public function get_port_count():Int {
		return ports.length;
	}

	public function to_string():String {
		return name;
	}

	public function resolve(context:Context):Context {
		throw new Exception("Not implemented.");
	}
	
	public function on_create_node(context:Context) {
		for (port in on_create_ports) {
			port.get_node_value(context);
		}
	}

}