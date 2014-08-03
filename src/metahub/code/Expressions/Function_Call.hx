package metahub.code.expressions;

import metahub.code.functions.Functions;
import metahub.code.Node_Signature;
import metahub.code.Scope;
import metahub.schema.Trellis;
import metahub.engine.Node;
import metahub.engine.General_Port;
import metahub.engine.Constraint_Operator;
import metahub.code.functions.Function;

class Function_Call implements Expression {
  var inputs:Array<Expression>;
	var func:Functions;
  //var func:Functions;

  public function new(func:Functions, type:Type_Signature, inputs:Array<Expression>) {
		this.func = func;
    this.inputs = inputs;
    //func = Type.createEnum(Functions, trellis.name);
  }

  public function resolve(scope:Scope):Dynamic {
		throw new Exception("Code not written for imperative function calls.");
    //return to_port(scope).parent.id;
  }

  public function to_port(scope:Scope, group:Group, node_signature:Node_Signature):General_Port {
		var hub = scope.hub;
		if (func == Functions.equals) {
			return inputs[0].to_port(scope, group, node_signature);
		}
		var info = hub.function_library.get_function_class(func, node_signature.signature);
		var node:Function = Type.createInstance(info.type, [hub, hub.nodes.length, info.trellis]);
    hub.add_internal_node(node);
		var expressions = inputs;
    var ports = node.get_inputs();
    var target:General_Port = null;
    for (i in 0...expressions.length) {
      if (i < ports.length) {
        target = ports[i];
      }

      var source = expressions[i].to_port(scope, group, node_signature.children[i]);
      target.connect(source);
    }

    var output = node.get_port(0);
		group.nodes.unshift(node);
    return output;
  }

	function get_args(scope:Scope, group:Group, node_signature:Node_Signature) {
		var result = new Array<General_Port>();
		var x = 0;
		for (i in inputs) {
			result.push(i.to_port(scope, group, node_signature.children[x++]));
		}

		return result;
	}

	//function args_types(args:Array < General_Port > ) {
		//var result = new Array<Type_Signature>();
		//for (a in args) {
			//result.push(a.get_type());
		//}
//
		//return result;
	//}

	public function get_type():Type_Signature {
		throw new Exception("Function.get_type() is not implemented.");
	}
}