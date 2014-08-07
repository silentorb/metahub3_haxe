package metahub.code.symbols;

import metahub.code.references.*;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.engine.Port;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.code.references.Reference;
import metahub.code.Scope_Definition;


class Local_Symbol implements Symbol {
  public var type:Type_Signature;
  public var scope_definition:Scope_Definition;
  public var index:Int;
  public var name:String;

  public function new(type:Type_Signature, scope_definition:Scope_Definition, index:Int, name:String) {
    this.type = type;
    this.scope_definition = scope_definition;
    this.index = index;
    this.name = name;
		//symbol_type = Symbol_Type.local;
  }

  public function get_node(scope:Scope):Node {
    var id = resolve(scope);
    return scope.hub.get_node(id);
  }

	public function get_trellis():Trellis {
		return type.trellis;
	}

	public function get_layer() {
		return Layer.engine;
	}

	public function get_type():Type_Signature {
		return type;
	}

  public function resolve(scope:Scope):Dynamic {
    if (scope_definition.depth == scope.definition.depth)
      return scope.values[index];

    if (scope.parent == null)
      throw new Exception("Could not find scope for symbol: " + name + ".");

    return resolve(scope.parent);
  }

	//public function get_port(scope:Scope, path:Property_Chain = null):Port {
		//var node = get_node2(scope, path);
    //return node.get_port(path[path.length - 1].id);
  //}

  //function get_node2(scope:Scope, path:Property_Chain):Node {
    //var node = get_node(scope);
    //var i = 0;
    //var length = path.length - 1;
    //while (i < length) {
      //var id = node.get_value(path[i].id);
      //node = scope.hub.get_node(id);
      //++i;
    //}
//
    //return node;
  //}

	//public function create_reference(path:Array<String>):Symbol_Reference {
		//var trellis = get_trellis();
		//var chain = Property_Chain_Helper.from_string(path, trellis);
		//if (chain.length == 0) {
			//if (type.type == Kind.reference)
				//return new Node_Reference(this, chain);
//
			//return new Port_Reference(this, chain);
		//}
		//else {
			//trace(chain);
			//var last_property = chain[chain.length - 1];
			//if (last_property.other_trellis == null)
				//return new Node_Reference(this, chain);
//
			//return new Port_Reference(this, chain);
		//}
	//}
}