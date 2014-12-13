package metahub.code.expressions;

import metahub.code.nodes.Group;
import metahub.code.Type_Signature;
import metahub.imperative.schema.Railway;
import metahub.Hub;
import metahub.engine.General_Port;

interface Expression {
	function get_type(out_type:Type_Signature = null):Array<Type_Signature>;
  function to_port(scope:Scope, group:Group, node_signature:Type_Signature):General_Port;
	function to_string():String;
	var children:Array<Expression>;
}
