package code;
import Hub;

interface Expression {
  var type:Type_Reference;
  function resolve(scope:Scope):Dynamic;
}
