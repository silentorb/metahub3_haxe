package metahub.schema;

import metahub.schema.Property;
import metahub.schema.Trellis;

class Schema {
  public var trellises:Array<Trellis> = new Array<Trellis>();
  var namespaces:Map<String, Namespace> = new Map<String, Namespace>();
	
	public function add_namespace(name:String):Namespace {
		if (namespaces.exists(name))
			return namespaces[name];
		
		var namespace = new Namespace(name, name);
		this.namespaces[name] = namespace;
		return namespace;
	}

  function add_trellis(name:String, trellis:Trellis):Trellis {
    trellises.push(trellis);
    return trellis;
  }

  public function load_trellises(trellises:Dynamic, namespace:Namespace) {
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
    }

// Initialize parents
    for (name in Reflect.fields(trellises)) {
      source = Reflect.field(trellises, name);
      trellis =  namespace.trellises[name];
      trellis.initialize1(source, namespace);
    }

		// Connect everything together
    for (name in Reflect.fields(trellises)) {
      source = Reflect.field(trellises, name);
      trellis =  namespace.trellises[name];
      trellis.initialize2(source);
    }
  }

  public function get_trellis(name:String, namespace:Namespace, throw_exception_on_missing = false):Trellis {
		if (name.indexOf('.') > -1)
			throw new Exception('Namespace paths are not supported yet.', 400);

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