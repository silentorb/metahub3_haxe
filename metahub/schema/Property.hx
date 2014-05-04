package metahub.schema;
import metahub.schema.Trellis;

typedef IProperty_Source = {
  ?default_value:Dynamic,
  ?allow_null:Bool,
  ?trellis:String,
  ?other_property:String
}

@:expose class Property {
  public var name:String;
  public var default_value:Dynamic;
  public var allow_null:Bool;
  public var trellis:Trellis;
  public var id:Int;
  public var other_trellis:Trellis;
  public var other_property:Property;

  public function new(name:String, source:IProperty_Source, trellis:Trellis) {
    if (source.default_value != null)
      this.default_value = source.default_value;

    if (source.allow_null != null)
      this.allow_null = source.allow_null;

    this.name = name;
    this.trellis = trellis;
  }

  public function initialize_links(source:IProperty_Source) {
    if (source.trellis != null) {
      this.other_trellis = this.trellis.hub.get_trellis(source.trellis);
      if (source.other_property != null)
        this.other_property = other_trellis.get_property(source.other_property);
      else {
        var other_properties = Lambda.filter(other_property.trellis.properties, function(p) { return p.other_trellis == this.trellis; });
        if (other_properties.length == 0)
          throw 'Could not find other property for ' + this.trellis.name + '.' + this.name + '.';

        if (other_properties.length > 1) {
          throw 'Multiple ambiguous other properties for ' + this.trellis.name + '.' + this.name + '.';
//        var direct = Lambda.filter(other_properties, function(p) { return p.other_property})
        }
        else {
          this.other_property = other_properties.first();
        }

      }
    }
  }

}