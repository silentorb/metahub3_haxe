package metahub.code.expressions;

import metahub.code.functions.Functions;
import metahub.schema.Trellis;
import metahub.engine.Node;
import metahub.engine.IPort;
import metahub.engine.Constraint_Operator;

class Function_Call implements Expression {
  public var type:Type_Reference;
  var inputs:Array<Expression>;
	var func:Functions;
  //var func:Functions;

  public function new(func:Functions, type:Type_Reference, inputs:Array<Expression>) {
		this.func = func;
    this.inputs = inputs;
		this.type = type;
    //func = Type.createEnum(Functions, trellis.name);
  }

  public function resolve(scope:Scope):Dynamic {
		throw new Exception("Code not written for imperative function calls.");
    //return to_port(scope).parent.id;
  }

  public function to_port(scope:Scope):IPort {
		var hub = scope.hub;
		var info = hub.function_library.get_function_class(func, type.type);
		var node = Type.createInstance(info.type, [hub, hub.nodes.length, info.trellis]);
    hub.add_node(node);
		var expressions = inputs;
    var ports = node.get_inputs();
    var target:IPort = null;
    for (i in 0...expressions.length) {
      if (i < ports.length) {
        target = ports[i];
      }

      var source = expressions[i].to_port(scope);
      target.connect(source);
    }

    var output = node.get_port(0);
    return output;
  }
}