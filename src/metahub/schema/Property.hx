package metahub.schema;
import metahub.schema.Trellis;

typedef IProperty_Source = {
	type:String,
  ?default_value:Dynamic,
	?allow_null:Bool,
	?trellis:String,
  ?other_property:String,
	?other_type: String,
	?multiple:Bool
}

@:expose class Property {
  public var name:String;
  public var type:Kind;
  public var default_value:Dynamic;
  public var allow_null:Bool;
  public var trellis:Trellis;
  public var id:Int;
  public var other_trellis:Trellis;
  public var other_property:Property;
  public var multiple:Bool = false;

  public function new(name:String, source:IProperty_Source, trellis:Trellis) {
		#if php
		if (source.type == "list") // Hack to fix bug in Haxe/PHP, which changes "list" to "hlist"
			this.type = Kind.list;
		else
		#end
			this.type = cast Reflect.field(Kind, source.type);

    if (Reflect.hasField(source, 'default'))
      this.default_value = Reflect.field(source, 'default');

    if (source.allow_null != null)
      this.allow_null = source.allow_null;

		if (source.multiple != null)
			multiple = source.multiple;

    this.name = name;
    this.trellis = trellis;
  }

  //public function add_dependency(other:Property_Reference):Void {
		//this.dependencies.push(other);
    ////other.dependents.push(new Property_Reference(this));
	//}

	public function fullname():String {
		return trellis.name + '.' + name;
	}

  public function get_default():Dynamic {
    if (default_value != null)
      return default_value;

    switch (type) {
      case Kind.int:
        return 0;

      case Kind.float:
        return 0;

      case Kind.string:
        return '';

      case Kind.bool:
        return false;

      default:
        return null;

    }
  }

  public function initialize_link1(source:IProperty_Source) {
		if (source.type != 'list' && source.type != 'reference')
      return;

    this.other_trellis = this.trellis.schema.get_trellis(source.trellis, trellis.namespace);
			if (this.other_trellis == null)
				throw new Exception("Could not find other trellis for " + fullname() + ".");
	}

  public function initialize_link2(source:IProperty_Source) {
    if (source.type != 'list' && source.type != 'reference')
      return;

    if (source.other_property != null) {
      other_property = other_trellis.get_property(source.other_property);
			if (other_property == null) {
				other_property = other_trellis.add_property(source.other_property, {
					type: source.other_type,
					trellis: trellis.name,					
					other_property: name
				});
				other_property.other_trellis = trellis;
				other_property.other_property = this;
				other_trellis.properties.push(other_property);
			}
		}
    else {

      var other_properties = Lambda.filter(this.other_trellis.properties, function(p) { return p.other_trellis == this.trellis; });
//        throw new Exception('Could not find other property for ' + this.trellis.name + '.' + this.name + '.');

      if (other_properties.length > 1) {
        throw new Exception('Multiple ambiguous other properties for ' + this.trellis.name + '.' + this.name + '.');
//        var direct = Lambda.filter(other_properties, function(p) { return p.other_property})
      }
      else if (other_properties.length == 1) {
        this.other_property = other_properties.first();
        this.other_property.other_trellis = this.trellis;
        this.other_property.other_property = this;
      }
			else {
				if (!other_trellis.is_value) {
					if (other_trellis.namespace.is_external)
						return;
						
					throw new Exception("Could not find other property for " + fullname());
				}
			}
    }
  }
	
	//public function get_signature() {
		//var result = new Type_Signature(type, other_trellis);
//
		////if (other_trellis != null && other_trellis.is_value)
			////result.is_numeric = other_trellis.is_numeric;
//
		//return result;
	//}

}