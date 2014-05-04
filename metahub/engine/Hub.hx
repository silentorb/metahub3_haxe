package metahub.engine;
import metahub.schema.Trellis;
import metahub.schema.Property;

class Hub {
  public var trellises:Array<Trellis> = new Array<Trellis>();
  public var trellis_keys:Map<String, Trellis> = new Map<String, Trellis>();

  public function new() {

  }

  function add_trellis(name:String, trellis:Trellis) {
    trellis_keys[name] = trellis;
    trellises.push(trellis);
  }

  public function load_trellises(trellises:Map<String, ITrellis_Source>) {
// Due to cross referencing, loading trellises needs to be done in passes

// First load the core trellises
    var trellis:Trellis, source:ITrellis_Source, name:String;
    for (name in trellises.keys()) {
      source = trellises[name];
      trellis = this.trellis_keys[name];
      if (trellis == null)
        add_trellis(name, new Trellis(name, this));

      trellis.load_properties(source);
    }

// Connect everything together
    for (name in trellises.keys()) {
      source = trellises[name];
      trellis = this.trellis_keys[name];
      trellis.initialize(source);
    }
  }

  public function get_trellis(name:String):Trellis {
    if (!this.trellis_keys.exists(name))
      throw 'Could not find trellis named: ' + name + '.';

    return this.trellis_keys[name];
  }

}