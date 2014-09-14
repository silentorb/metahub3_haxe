package metahub.code.expressions;
import haxe.macro.Context;
import metahub.code.expressions.Expression;
import metahub.code.nodes.Empty_Resolution;
import metahub.code.nodes.Group;
import metahub.code.Scope;
import metahub.code.Scope_Definition;
import metahub.code.expressions.Block;
import metahub.code.Type_Signature;
import metahub.schema.Trellis;
import metahub.schema.Property;
import metahub.engine.General_Port;
import metahub.schema.Kind;

class Create_Node implements Expression {
  public var trellis:Trellis;
  //public var assignments = new Map<Int, Expression>();
	var block:Expression;
  public var trellis_type:Type_Signature;
	var scope_definition:Scope_Definition;
	public var children:Array<Expression>;

  public function new(trellis:Trellis, scope_definition:Scope_Definition, block:Expression) {
    this.trellis = trellis;
    trellis_type = new Type_Signature(Kind.reference, trellis);
		this.scope_definition = scope_definition;
		this.block = block;
		children = block != null
			? [ block ]
			: [];
  }

	public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var block_port:General_Port = null;
		var creator = new metahub.code.nodes.Create_Node(trellis, scope.hub, group);
		if (block != null) {
			var new_scope = new Scope(scope.hub, scope_definition, scope);
			//new_scope.node = node;
			block_port = block.to_port(new_scope, group, signature_node);
			creator.get_port(1).connect(block_port);
		}

		return creator.get_port(0);
	}

	public function get_type(out_type:Type_Signature = null):Array<Type_Signature> {
		return [ trellis_type, new Type_Signature(Kind.none) ];
	}

	public function to_string():String {
		return "new " + trellis.name;
	}

}