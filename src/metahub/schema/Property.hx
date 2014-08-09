package metahub.schema;
import metahub.code.functions.Functions;
import metahub.engine.INode;
import metahub.schema.Trellis;
import metahub.code.Type_Signature;

typedef IProperty_Source = {
	type:String,
  ?default_value:Dynamic,
	?allow_null:Bool,
	?trellis:String,
  ?other_property:String,
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

    if (source.default_value != null)
      this.default_value = source.default_value;

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

  public function initialize_link(source:IProperty_Source) {
    if (source.type != 'list' && source.type != 'reference')
      return;

    this.other_trellis = this.trellis.schema.get_trellis(source.trellis, trellis.namespace);
    if (source.other_property != null)
      this.other_property = other_trellis.get_property(source.other_property);
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
    }
  }

	public function get_signature() {
		var result = new Type_Signature(type, other_trellis);

		//if (other_trellis != null && other_trellis.is_value)
			//result.is_numeric = other_trellis.is_numeric;

		return result;
	}

}