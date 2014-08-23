package metahub.code.expressions;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Group;
import metahub.code.Scope;
import metahub.code.Scope_Definition;
import metahub.code.expressions.Block;
import metahub.code.statements.Statement;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Node implements Expression {
  public var trellis:Trellis;
  //public var assignments = new Map<Int, Expression>();
	public var block:Expression;
  public var trellis_type:Type_Signature;
	var scope_definition:Scope_Definition;

  public function new(trellis:Trellis, scope_definition:Scope_Definition) {
    this.trellis = trellis;
    trellis_type = new Type_Signature(Kind.reference, trellis);
		this.scope_definition = scope_definition;
  }

	public function to_port(scope:Scope, group:Group, signature_node:Node_Signature):General_Port {
		var block_port:General_Port = null;
		var creator = new metahub.code.nodes.Create_Node(trellis, scope.hub);
		if (block != null) {
			var new_scope = new Scope(scope.hub, scope_definition, scope);
			//new_scope.node = node;
			block_port = block.to_port(new_scope, group, signature_node);
			creator.get_port(1).connect(block_port);
		}

		return creator.get_port(0);
	}

	public function get_types():Array<Array<Type_Signature>>{
		return [ [ trellis_type ] ];
	}

	public function to_string():String {
		return "new " + trellis.name;
	}

	public function get_children():Array<Expression> {
		return [];
	}
//
	//public function resolve(scope:Scope):Dynamic {
		//trace('create node', trellis.name);
    //var node = scope.hub.create_node(trellis);
		//var new_scope = new Scope(scope.hub, scope_definition, scope);
		//new_scope.node = node;
		//if (block != null) {
			//var block_port = block.to_port(scope,
			//block.resolve(new_scope);
		//}
//
    ////for (i in assignments.keys()) {
      ////var statement = assignments[i];
			////var input_type = Type_Signature.from_property(trellis.properties[i]);
      ////node.set_value(i, Expression_Utility.resolve(statement, input_type, scope));
    ////}
//
    //return node;
	//}

}