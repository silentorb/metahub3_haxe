package metahub.code;
import metahub.engine.INode;
import haxe.ds.Vector;
import metahub.engine.Node;

class Scope {
  public var hub:Hub;
  public var definition:Scope_Definition;
  public var values:Vector<Dynamic>;
  public var parent:Scope;

  public function new(hub:Hub, definition:Scope_Definition, parent:Scope = null) {
    this.hub = hub;
    this.definition = definition;
    this.parent = parent;
    values = new Vector<Dynamic>(definition.size());
  }

  //public function create_reference(reference:Symbol_Reference):Reference {
    //if (reference.symbol.scope_definition.depth == definition.depth) {
      //var id = values[reference.symbol.index];
      //var node = hub.nodes[id];
      //var result = new Reference(node);
      //return result;
    //}
//
    //if (parent == null)
      //throw new Exception("Could not find scope for symbol: " + reference.symbol.name + ".");
//
    //return parent.create_reference(reference);
  //}

  public function set_value(index:Int, value:Dynamic) {
    values[index] = value;
  }

}