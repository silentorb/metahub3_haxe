package metahub.code.expressions;

import metahub.schema.Trellis;
import metahub.engine.Node;
import metahub.engine.IPort;

class Function_Call implements Expression {
  public var type:Type_Reference;
  var inputs:Array<Expression>;
  var trellis:Trellis;
  //var func:Functions;

  public function new(trellis:Trellis, inputs:Array<Expression>) {
    this.trellis = trellis;
    this.inputs = inputs;
    //func = Type.createEnum(Functions, trellis.name);
  }

  public function resolve(scope:Scope):Dynamic {
		throw new Exception("Code not written for imperative function calls.");
    //return to_port(scope).parent.id;
  }

  public function to_port(scope:Scope):IPort {
    var node = scope.hub.create_node(trellis);
		var expressions = inputs;
    var ports = node.get_inputs();
    var target:IPort = null;
    for (i in 0...expressions.length) {
      if (i < ports.length) {
        target = ports[i];
      }

      var source = expressions[i].to_port(scope);
      target.add_dependency(source);
    }

    var output = node.get_port(0);
    return output;
  }
}