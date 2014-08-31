package metahub.code.expressions;

import metahub.code.functions.Functions;
import metahub.code.Node_Signature;
import metahub.code.nodes.Group;
import metahub.engine.Node_Context;

import metahub.code.Type_Signature;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.engine.Node;
import metahub.engine.General_Port;
import metahub.engine.Constraint_Operator;
import metahub.code.functions.Function;

class Function_Call implements Expression {
  var inputs:Array<Expression>;
	var func:Functions;
	var hub:Hub;
  //var func:Functions;

  public function new(func:Functions, inputs:Array<Expression>, hub:Hub) {
		this.hub = hub;
		this.func = func;
    this.inputs = inputs;
    //func = Type.createEnum(Functions, trellis.name);
  }

  public function resolve(scope:Scope):Dynamic {
		throw new Exception("Code not written for imperative function calls.");
    //return to_port(scope).parent.id;
  }

  public function to_port(scope:Scope, group:Group, node_signature:Node_Signature):General_Port {
		if (func == Functions.equals) {
			return inputs[0].to_port(scope, group, node_signature);
		}
		var info = hub.function_library.get_function_info(func, node_signature.signature);
		var node:Function = Type.createInstance(info.type, [hub, hub.get_node_count(), func, node_signature.signature, group]);
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

	public function get_types():Array < Array < Type_Signature >> {
		if (func == Functions.equals)
			return null;

		var options = hub.function_library.get_function_options(func);
		var result = new Array < Array < Type_Signature >> ();
		for (option in options) {
			result.push(option.signature);
		}

		return result;
	}

	public function to_string():String {
		return Std.string(func);
	}

	public function get_children():Array<Expression> {
		return inputs;
	}

	public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		var port = to_port(scope, null, node_signature);
		return port.get_node_value(new Node_Context(scope.node, scope.node.hub));
	}

}