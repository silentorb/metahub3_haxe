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
		var result = new Path_Node(group, scope.definition.trellis);
		var type_unknown = new Type_Signature(Kind.unknown);

		var token_port = result.get_port(1);
		var previous:Type_Signature = type_unknown.copy();
		var port:General_Port = null;

		for (i in 0...children.length) {
			if (i > 0) {
				previous = children[i - 1].get_type(previous)[0].copy();
			}

			var expression:Token_Expression = cast children[i];
			var signature = [ type_unknown.copy(), previous ];
			port = expression.to_token_port(scope, group, signature, i == children.length - 1, port);
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