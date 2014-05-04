package metahub.schema;
import metahub.engine.Hub;
import metahub.schema.Property;

typedef ITrellis_Source = {
  var name:String;
  var properties:Map<String, IProperty_Source>;
  var parent:String;
}

class Trellis {
  public var name:String;
  public var hub:Hub;
  public var properties:Array<Property> = new Array<Property>();
  var property_keys:Map<String, Property> = new Map<String, Property>();
  var parent:Trellis;

  public function new(name:String, hub:Hub) {
    this.name = name;
    this.hub = hub;
  }

  public function add_property(name:String, source:IProperty_Source):Property {
    var property = new Property(name, source, this);
    this.property_keys[name] = property;
    property.id = this.properties.length;
    this.properties.push(property);
    return property;
  }

  public function get_all_properties() {
    var result = new Map<String, Property>();
    var tree = this.get_tree();
    for (trellis in tree) {
      for (property in trellis.properties) {
        result[property.name] = property;
      }
    }
    return result;
  }

  public function get_property(name:String) {
    var properties = this.get_all_properties();
    if (!properties.exists(name))
      throw this.name + ' does not contain a property named ' + name + '.';

    return properties[name];
  }

  public function get_tree():Array<Trellis> {
    var trellis = this;
    var tree = new Array<Trellis>();

    do {
      tree.unshift(trellis);
      trellis == trellis.parent;
    }
    while (trellis != null);

    return tree;
  }

  public function load_properties(source:ITrellis_Source) {
    for (name in source.properties.keys()) {
      add_property(name, source.properties[name]);
    }
  }

  public function initialize(source:ITrellis_Source) {
    var trellises = this.hub.trellises;
    if (source.parent != null) {
      var trellis = this.hub.get_trellis(source.parent);
      this.set_parent(trellis);
    }

    if (source.properties != null) {
      for (j in source.properties.keys()) {
        var property:Property = this.get_property(j);
        property.initialize_links(source.properties[j]);
      }
    }
  }

  function set_parent(parent:Trellis) {
    this.parent = parent;

//    if (!parent.identity)
//      throw new Error(parent.name + ' needs a primary key when being inherited by ' + this.name + '.');
//
//    this.identity = parent.identity.map((x) => x.clone(this))
  }
}