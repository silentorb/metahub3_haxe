package metahub.code.expressions;

import metahub.code.functions.Function_Library;
import metahub.code.functions.Functions;
import metahub.code.Node_Signature;
import metahub.code.nodes.Group;
import metahub.engine.Node_Context;
import metahub.Hub;
import metahub.schema.Namespace;

import metahub.code.Type_Signature;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.engine.Node;
import metahub.engine.General_Port;
import metahub.engine.Constraint_Operator;
import metahub.code.functions.Function;

typedef Function_Info = {
	library:Function_Library,
	index:Int
}

class Function_Call implements Token_Expression {
  public var children:Array<Expression>;
	var function_string:String;
	var hub:Hub;
	var info:Function_Info;

  public function new(func:String, info:Function_Info, inputs:Array<Expression>, hub:Hub) {
		this.hub = hub;
		this.function_string = func;
    this.children = inputs;
		this.info = info;
		//info = get_function_info(func, hub);
  }

	public static function get_function_info(function_string:String, hub:Hub):Function_Info {
		var path = function_string.split('.');
		var name = path.pop();
		var namespace = hub.metahub_namespace.get_namespace(path);
		var library = namespace.function_library;
		return {
			library: library,
			index: library.get_function_id(name)
		};
	}

  public function to_port(scope:Scope, group:Group, node_signature:Type_Signature):General_Port {
		if (function_string == "equals") {
			return children[0].to_port(scope, group, node_signature);
		}
		if (node_signature == null) {
			node_signature = get_type()[0];
		}
		return _to_port(scope, group, [ node_signature ] );
	}

  function _to_port(scope:Scope, group:Group, signature:Array < Type_Signature > , previous_port:General_Port = null):General_Port {
		var function_signature = determine_signature(info.library, signature);
		//var info = info.library.get_function_info(this.info.index, function_signature);
		//var node:Function = Type.createInstance(info.type, [hub, this.info.index, function_signature, group, false]);
		var node = info.library.create_node(info.index, function_signature, group, false);
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
		if (previous_port != null) {
			node.get_port(1).connect(previous_port);
		}
    return node.get_port(0);
  }

  public function to_token_port(scope:Scope, group:Group, signature:Array<Type_Signature>, is_last:Bool, previous_port:General_Port):General_Port {
		return _to_port(scope, group, signature, previous_port);
  }

	public function determine_signature(function_library:Function_Library, requirement:Array<Type_Signature>) {
		var options = function_library.get_function_options(info.index);
		for (child in children) {
			requirement.push(child.get_type()[0]);
		}
		for (option in options) {
			if (Type_Network.signatures_match(requirement, option)) {
				var result = [];
				for (i in 0...requirement.length) {
					var type = requirement[i].copy();
					type.resolve(option[i]);
					result.push(type);
				}
				return result;
			}
		}

		throw new Exception("Could not find valid function type.");
	}

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		if (function_string == "equals") {
			var type = children[0].get_type()[0];
			return [ type ];
		}

		var options = info.library.get_function_options(info.index);

		if (out_type == null) {
			//throw new Exception("out_type required for determining function type.");
			var signature:Array<Type_Signature> = [ new Type_Signature(Kind.unknown) ];
			for (child in children) {
				signature.push(child.get_type()[0]);
			}

			for (option in options) {
				if (Type_Signature.arrays_match(option, signature))
					return [signature[1]];
			}

			throw new Exception("out_type required for determining function type.");
		}

		for (option in options) {
			if (out_type.equals(option[0]))
				return option;
		}

		throw new Exception("Could not find valid function type.");
	}

	public function to_string():String {
		return function_string;
	}

	//public function get_value(scope:Scope, node_signature:Node_Signature):Dynamic {
		//var port = to_port(scope, null, node_signature);
		//return port.get_node_value(new Node_Context(scope.node, scope.node.hub));
	//}

	public static function instantiate(function_info:Function_Info, signature:Array<Type_Signature>, group:Group, hub:Hub, is_constraint:Bool):Function {
		var function_signature = determine_signature2(signature, function_info, hub);
		//var info = function_info.library.get_function_info(function_info.index, function_signature);
		var node:Function = function_info.library.create_node(function_info.index, signature, group, is_constraint);
    hub.add_internal_node(node);
		return node;
	}

	static function determine_signature2(requirement:Array<Type_Signature>, info:Function_Info, hub:Hub) {
		var options = info.library.get_function_options(info.index);
		for (option in options) {
			if (Type_Network.signatures_match(requirement, option)) {
				var result = [];
				for (i in 0...requirement.length) {
					var type = requirement[i].copy();
					type.resolve(option[i]);
					result.push(type);
				}
				return result;
			}
		}

		throw new Exception("Could not find valid function type.");
	}
}