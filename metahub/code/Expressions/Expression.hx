package code.expressions;

import Hub;
import engine.IPort;

interface Expression {
  var type:Type_Reference;
  function resolve(scope:Scope):Dynamic;
  function to_port(scope:Scope):IPort;
}
