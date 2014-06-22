package metahub.code.symbols;

import metahub.code.references.*;
import metahub.engine.IPort;
import metahub.engine.Node;
import metahub.schema.Trellis;
import metahub.schema.Property_Chain;
import metahub.schema.Kind;
import metahub.code.references.Reference;

class Local_Symbol implements Symbol {
  public var type:Type_Reference;
  public var scope_definition:Scope_Definition;
  public var index:Int;
  public var name:String;

  public function new(type:Type_Reference, scope_definition:Scope_Definition, index:Int, name:String) {
    this.type = type;
    this.scope_definition = scope_definition;
    this.index = index;
    this.name = name;
		//symbol_type = Symbol_Type.local;
  }

  public function get_node(scope:Scope):Node {
    var id = resolve(scope);
    return scope.hub.nodes[id];
  }

	public function get_trellis():Trellis {
		return type.trellis;
	}

	public function get_layer() {
		return Layer.engine;
	}

  public function resolve(scope:Scope):Dynamic {
    if (scope_definition.depth == scope.definition.depth)
      return scope.values[index];

    if (scope.parent == null)
      throw new Exception("Could not find scope for symbol: " + name + ".");

    return resolve(scope.parent);
  }

	public function get_port(scope:Scope, path:Property_Chain = null):IPort {
		var node = get_node2(scope, path);
    return node.get_port(path[path.length - 1].id);
  }

  function get_node2(scope:Scope, path:Property_Chain):Node {
    var node = get_node(scope);
    var nodes = scope.hub.nodes;
    var i = 0;
    var length = path.length - 1;
    while (i < length) {
      var id = node.get_value(path[i].id);
      node = nodes[id];
      ++i;
    }

    return node;
  }

	public function create_reference(path:Array<String>):Reference<Local_Symbol> {
		var trellis = get_trellis();
		var chain = Property_Chain_Helper.from_string(path, trellis);
		if (chain.length == 0) {
			if (type.type == Kind.reference)
				return new Node_Reference(this, chain);

			return new Port_Reference(this, chain);
		}
		else {
			trace(chain);
			var last_property = chain[chain.length - 1];
			if (last_property.other_trellis == null)
				return new Node_Reference(this, chain);

			return new Port_Reference(this, chain);
		}
	}
}