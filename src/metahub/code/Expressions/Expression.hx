package metahub.code.expressions;

import metahub.code.nodes.Group;
import metahub.code.Type_Signature;
import metahub.Hub;
import metahub.engine.General_Port;

interface Expression {
	function get_types():Array<Array<Type_Signature>>;
  function to_port(scope:Scope, group:Group, node_signature:Node_Signature):General_Port;
	function to_string():String;
	var children:Array<Expression>;
}
