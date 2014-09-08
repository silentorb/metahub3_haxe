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
  public var children:Array<Expression>;
	var func:Functions;
	var hub:Hub;

  public function new(func:Functions, inputs:Array<Expression>, hub:Hub) {
		this.hub = hub;
		this.func = func;
    this.children = inputs;
  }

  public function to_port(scope:Scope, group:Group, node_signature:Type_Signature):General_Port {
		if (func == Functions.equals) {
			return children[0].to_port(scope, group, node_signature);
		}

		if (node_signature == null) {
			node_signature = get_type()[0];
		}
		var function_signature = determine_signature(node_signature);
		var info = hub.function_library.get_function_info(func, function_signature);
		var node:Function = Type.createInstance(info.type, [hub, func, function_signature, group]);
    hub.add_internal_node(node);
		var expressions = children;
    var ports = node.get_inputs();
    var target:General_Port = null;
    for (i in 0...expressions.length) {
      if (i < ports.length) {
        target = ports[i];
      }

      var source = expressions[i].to_port(scope, group, function_signature[i + 1]);
      target.connect(source);
    }

    var output = node.get_port(0);
    return output;
  }

	//function get_args(scope:Scope, group:Group, node_signature:Node_Signature) {
		//var result = new Array<General_Port>();
		//var x = 0;
		//for (i in children) {
			//result.push(i.to_port(scope, group, node_signature.children[x++]));
		//}
//
		//return result;
	//}

	public function determine_signature(out_type:Type_Signature) {
		var options = hub.function_library.get_function_options(func);
		var requirement = [ out_type ];
		for (child in children) {
			requirement.push(child.get_type()[0]);
		}
		for (option in options) {
			if (Type_Network.signatures_match(requirement, option.signature)) {
				var result = [];
				for (i in 0...requirement.length) {
					var type = requirement[i].copy();
					type.resolve(option.signature[i]);
					result.push(type);
				}
				return result;
			}
		}

		throw new Exception("Could not find valid function type.");
	}

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		if (func == Functions.equals) {
			var type = children[0].get_type()[0];
			return [ type ];
		}

		var options = hub.function_library.get_function_options(func);

		if (out_type == null) {
			//throw new Exception("out_type required for determining function type.");
			var signature:Array<Type_Signature> = [ new Type_Signature(Kind.unknown) ];
			for (child in children) {
				signature.push(child.get_type()[0]);
			}

			for (option in options) {
				if (Type_Signature.arrays_match(option.signature, signature))
					return [signature[1]];
			}

			throw new Exception("out_type required for determining function type.");
		}

		for (option in options) {
			if (out_type.equals(option.signature[0]))
				return option.signature;
		}

		throw new Exception("Could not find valid function type.");
	}

	public function to_string():String {
		return Std.string(func);
	}

	//public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		//var port = to_port(scope, null, node_signature);
		//return port.get_node_value(new Node_Context(scope.node, scope.node.hub));
	//}

}