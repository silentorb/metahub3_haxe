package metahub.code.expressions;

import metahub.code.Group;
import metahub.code.Type_Signature;
import metahub.Hub;
import metahub.engine.General_Port;

interface Expression {
  //var type:Type_Reference;
	function get_type():Type_Signature;
  function to_port(scope:Scope, group:Group, node_signature:Node_Signature):General_Port;
}
