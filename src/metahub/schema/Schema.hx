package metahub.schema;

import metahub.schema.Property;
import metahub.schema.Trellis;

class Schema {
  //public var trellises:Array<Trellis> = new Array<Trellis>();
  public var root_namespace = new Namespace("root", "root");
	private var trellis_counter:Int = 1;

	public function add_namespace(name:String):Namespace {
		if (root_namespace.children.exists(name))
			return root_namespace.children[name];

		var namespace = new Namespace(name, name);
		root_namespace.children[name] = namespace;
		namespace.parent = root_namespace;
		return namespace;
	}

  function add_trellis(name:String, trellis:Trellis):Trellis {
		trellis.id = trellis_counter++;
    //trellises.push(trellis);
    return trellis;
  }

  public function load_trellises(trellises:Dynamic, settings:Load_Settings) {
		if (settings.namespace == null)
			settings.namespace = root_namespace;

		var namespace = settings.namespace;
// Due to cross referencing, loading trellises needs to be done in passes
//trace('t2',  Reflect.fields(trellises));
// First load the core trellises
    var trellis:Trellis, source:ITrellis_Source, name:String;
    for (name in Reflect.fields(trellises)) {

      source = Reflect.field(trellises, name);
      trellis = namespace.trellises[name];
			//trace('t', name);
      if (trellis == null)
        trellis = add_trellis(name, new Trellis(name, this, namespace));

      trellis.load_properties(source);

			if (settings.auto_identity && source.primary_key == null && source.parent == null) {
				var identity_property = trellis.get_property_or_null("id");
				if (identity_property == null) {
					identity_property = trellis.add_property("id", { type: "int" } );
				}

				trellis.identity_property = identity_property;
			}

    }

// Initialize parents
    for (name in Reflect.fields(trellises)) {
      source = Reflect.field(trellises, name);
      trellis = namespace.trellises[name];
      trellis.initialize1(source, namespace);
    }

		// Connect everything together
    for (name in Reflect.fields(trellises)) {
      source = Reflect.field(trellises, name);
      trellis = namespace.trellises[name];
      trellis.initialize2(source);
    }
  }

  public function get_trellis(name:String, namespace:Namespace, throw_exception_on_missing = false):Trellis {
		if (name.indexOf('.') > -1) {
			var path = name.split('.');
			name = path.pop();
			namespace = namespace.get_namespace(path);
		}			

		if (namespace == null)
				throw new Exception('Could not find namespace for trellis: ' + name + '.', 400);

		if (!namespace.trellises.exists(name)) {
			if (!throw_exception_on_missing)
				return null;

			throw new Exception('Could not find trellis named: ' + name + '.', 400);
		}
		return namespace.trellises[name];
  }

}