package code.expressions;

import schema.Trellis;
import engine.Node;
import engine.IPort;

class Function_Call implements Expression {
  public var type:Type_Reference;
  var inputs:Array<Expression>;
  var trellis:Trellis;
  var func:Functions;

  public function new(trellis:Trellis, inputs:Array<Expression>) {
    this.trellis = trellis;
    this.inputs = inputs;
    func = Type.createEnum(Functions, trellis.name);
  }

  public function resolve(scope:Scope):Dynamic {
		throw new Exception("Code not written for imperative function calls.");
    //return to_port(scope).parent.id;
  }

  public function to_port(scope:Scope):IPort {
    var node = scope.hub.create_node(trellis);
    var ports = node.get_inputs();
    var i = 0;
    var target:IPort = null;
    while (i < inputs.length) {
      if (i < ports.length) {
        target = ports[i];
				trace("Warning: Not sure what to do with port actions.");
        //target.action = func;
      }

      var source = inputs[i].to_port(scope);
      target.add_dependency(source);
      ++i;
    }

    var output = node.get_port(0);
    return output;
  }
}