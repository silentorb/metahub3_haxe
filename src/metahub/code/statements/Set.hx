package metahub.code.statements;
import metahub.code.expressions.Expression;
import metahub.code.Node_Signature;
import metahub.code.references.Reference;
import metahub.code.Setter;
import metahub.code.symbols.Local_Symbol;
import metahub.engine.INode;
import metahub.engine.Node;
import metahub.engine.General_Port;
/*
class Set implements Statement {
  var reference:Reference;
	public var block:Block;

  public function new(reference:Reference) {
    this.reference = reference;
  }

  public function add_assignment(reference:Reference, expression:Expression) {
    block.add(reference, expression);
  }

  public function resolve(scope:Scope):Dynamic {
    var node_id:Int = cast reference.resolve(scope);
		var node = scope.hub.get_node(node_id);
    setter.run(node, scope);

    return null;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
    return null;
  }

	public function get_type():Type_Signature {
		return reference.get_type();
	}

}*/