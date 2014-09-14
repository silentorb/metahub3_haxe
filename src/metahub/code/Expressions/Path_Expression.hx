package metahub.code.expressions;
import metahub.code.nodes.Context_Converter;
import metahub.code.nodes.Path_Node;
import metahub.code.references.*;
import metahub.code.Type_Signature;
import metahub.engine.General_Port;
import metahub.code.nodes.Group;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.engine.Node;
import metahub.code.nodes.Path_Condition;

class Path_Expression implements Expression {
	public var children = new Array<Expression>();

  public function new(children:Array<Expression>) {
    this.children = children;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		var result = new Path_Node(group);
		var type_unknown = new Type_Signature(Kind.unknown);

		var token_port = result.get_port(1);
		for (i in 0...children.length) {
			var expression:Token_Expression = cast children[i];
			var signature = [ type_unknown.copy(), type_unknown.copy() ];
			var port = expression.to_token_port(scope, group, signature, i == children.length - 1);
			token_port.connect(port);
		}
		return result.get_port(0);
  }

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		return children[children.length - 1].get_type(out_type);
	}

	public function to_string():String {
		return "Path";
	}
}