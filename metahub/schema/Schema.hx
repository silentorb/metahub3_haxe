package schema;

import schema.Property;
import schema.Trellis;

class Schema {
  public var trellises:Array<Trellis> = new Array<Trellis>();
  public var trellis_keys:Map<String, Trellis> = new Map<String, Trellis>();

  function add_trellis(name:String, trellis:Trellis):Trellis {
    trellis_keys[name] = trellis;
    trellises.push(trellis);
    return trellis;
  }

  public function load_trellises(trellises:Map<String, ITrellis_Source>) {
// Due to cross referencing, loading trellises needs to be done in passes

// First load the core trellises
    var trellis:Trellis, source:ITrellis_Source, name:String;
    for (name in Reflect.fields(trellises)) {

      source = Reflect.field(trellises, name);
      trellis = this.trellis_keys[name];
      if (trellis == null)
        trellis = add_trellis(name, new Trellis(name, this));

      trellis.load_properties(source);
    }

// Connect everything together
    for (name in Reflect.fields(trellises)) {
      source = Reflect.field(trellises, name);
      trellis = this.trellis_keys[name];
      trellis.initialize(source);
    }
  }

  public function get_trellis(name:String):Trellis {
    if (!this.trellis_keys.exists(name))
      throw new Exception('Could not find trellis named: ' + name + '.');

    return this.trellis_keys[name];
  }

}