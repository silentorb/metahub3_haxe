package metahub.code.expressions;

import metahub.code.Group;
import metahub.Hub;
import metahub.engine.General_Port;

interface Expression {
  var type:Type_Reference;
  function resolve(scope:Scope):Dynamic;
  function to_port(scope:Scope, group:Group):General_Port;
}
