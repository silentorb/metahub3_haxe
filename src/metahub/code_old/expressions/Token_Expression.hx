package metahub.code.expressions;
import metahub.code.nodes.Group;
import metahub.engine.General_Port;

/**
 * @author Christopher W. Johnson
 */

interface Token_Expression extends Expression {
  function to_token_port(scope:Scope, group:Group, signature:Array<Type_Signature>, is_last:Bool, previous_port:General_Port):General_Port;
}