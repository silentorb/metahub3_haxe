package metahub.meta;
import metahub.Hub;
import metahub.imperative.code.Parse;
import metahub.logic.schema.Signature;
import metahub.logic.schema.Railway;
import metahub.logic.schema.Tie;
import metahub.meta.types.Array_Expression;
import metahub.meta.types.Block;
import metahub.meta.types.Constraint;
import metahub.meta.types.Expression_Type;
import metahub.meta.types.Expression;
import metahub.meta.types.Function_Call;
import metahub.meta.types.Function_Scope;
import metahub.meta.types.Literal;
import metahub.meta.types.Parameter;
import metahub.meta.types.Path;
import metahub.meta.types.Property_Expression;
import metahub.meta.types.Scope_Expression;
import metahub.meta.types.Variable;
import metahub.schema.Kind;
import metahub.schema.Namespace;
import metahub.logic.schema.Rail;

typedef Conditions_Source = {
	type:String,
	conditions:Array<Dynamic>,
	mode:String
}

class Coder {
  var railway:Railway;

  public function new(railway:Railway) {
    this.railway = railway;
  }

  public function convert_expression(source:Dynamic, previous:Expression, scope:Scope):Expression {

    switch(source.type) {
			case 'block':
        return create_block(source, scope);
      case 'literal':
        return create_literal(source, scope);
      case 'path':
        return create_path(source, previous, scope);
			//case 'reference':
        //return create_general_reference(source, scope);
      case 'function':
				throw new Exception("Not supported.");
        return function_expression(source, scope, source.name, previous);

			//case 'create_node':
        //return create_node(source, scope);
			//case 'conditions':
        //return conditions(source, scope);
			//case 'condition':
        //return condition(source, scope);
			case 'array':
        return create_array(source, scope);
			//case 'lambda':
        //return create_lambda(source, scope);
    }

    throw new Exception("Invalid block: " + source.type);
  }

	public function convert_statement(source:Dynamic, scope:Scope, type:Signature = null):Expression {

    switch(source.type) {
      case 'block':
        return create_block(source, scope);
      //case 'symbol':
        //return create_symbol(source, scope);
			case 'new_scope':
				return new_scope(source, scope);
			//case 'create_node':
        //return create_node(source, scope);
			//case 'if':
        //return if_statement(source, scope);
      case 'constraint':
        return constraint(source, scope);
      case 'function_scope':
        return function_scope(source, scope);
			//case 'weight':
        //return weight(source, scope);
		}

    throw new Exception("Invalid block: " + source.type);
  }

  function constraint(source:Dynamic, scope:Scope):Expression {
		//var reference = Reference.from_scope(source.path, scope);
		var reference = convert_expression(source.reference, null, scope);
		var back_reference:Expression = null;
		var operator_name = source.operator;
		if (['+=', '-=', '*=', '/='].indexOf(operator_name) > -1) {
			//operator_name = operator_name.substring(0, operator_name.length - 7);
			back_reference = reference;
		}
		var expression = Parse.resolve(convert_expression(source.expression, null, scope));

		return new Constraint(reference, expression, operator_name,
			source.lambda != null ? cast create_lambda(source.lambda, scope, [ reference, expression ]) : null
		);
		
		
  }

  function create_block(source:Dynamic, scope:Scope):Expression {
		var count = Reflect.fields(source.expressions).length;
    if (count == 0)
			return new Block();

		var fields = Reflect.fields(source.expressions);

		if (count == 1) {
			var expression = Reflect.field(source.expressions, fields[0]);
      return convert_statement(expression, scope);
		}
    var block = new Block();

    for (e in fields) {
      var child = Reflect.field(source.expressions, e);
      block.children.push(convert_statement(child, scope));
    }

    return block;
  }

  function create_literal(source:Dynamic, scope:Scope):Expression {
    var type = get_type(source.value);
    //return new metahub.code.expressions.Literal(source.value, type);
		return new Literal(source.value);
  }

  function function_expression(source:Dynamic, scope:Scope, name:String, previous:Expression):Expression {
    var expressions:Array<Dynamic> = source.inputs;
		if (source.inputs.length > 0)
			throw new Exception("Not supported.");

    //var inputs = Lambda.array(Lambda.map(expressions, function(e) return convert_expression(e, scope)));

		return new Function_Call(name, previous, railway);
		//var info = Function_Call.get_function_info(name, hub);
    //return new metahub.code.expressions.Function_Call(name, info, inputs, hub);
  }

	function extract_path(path:Dynamic):Array<String> {
		var result = new Array<String>();
		for (i in 1...path.length) {
			result.push(path[i]);
		}

		return result;
	}

  function create_path(source:Dynamic, previous:Expression, scope:Scope):Expression {
		var rail:Rail = scope.rail;
		var expression:Expression = null;
		var children = new Array<Expression>();
		var expressions:Array<Dynamic> = source.children;
		if (expressions.length == 0)
			throw new Exception("Empty reference path.");

		if (expressions[0].type == "reference" && rail.get_tie_or_null(expressions[0].name) == null
			&& scope.find(expressions[0].name) == null) {
				throw new Exception("Not supported.");
		}

		for (item in expressions) {
			switch (item.type) {
				case "function":
					previous = new Function_Call(item.name, previous, railway);
					//var info = Function_Call.get_function_info(item.name, hub);
					//children.push(new metahub.code.expressions.Function_Call(item.name, info, [], hub));
				case "reference":
					var variable = scope.find(item.name);
					if (variable != null) {
						previous = new Variable(item.name);
						if (variable.rail == null)
							throw "";
						rail = variable.rail;
					}
					else {
						var tie:Tie = cast rail.get_tie_or_error(item.name);
						previous = new Property_Expression(tie);
						if (tie.other_rail != null)
							rail = tie.other_rail;
					}
				case "array":
					var items:Array<Dynamic> = cast item.expressions;
					var token:Expression = null;
					var sub_array = [];
					for (item in items) {
						var token = convert_expression(item, token, scope);
						sub_array.push(token);
					}
					previous = new Array_Expression(sub_array);

				default:
					throw new Exception("Invalid path token type: " + item.type);
			}

			children.push(previous);
		}
		return new Path(children);
  }

  static function get_type(value:Dynamic):Signature {
    if (Std.is(value, Int)) {
      return {
					type: Kind.unknown,
					is_numeric: 1
			}
		}

    if (Std.is(value, Float))
      return { type: Kind.float };

    if (Std.is(value, Bool))
      return { type: Kind.bool };

    if (Std.is(value, String))
      return { type: Kind.string };

    throw new Exception("Could not find type.");
  }

	function new_scope(source:Dynamic, scope:Scope):Expression {
		var path:Array<String> = source.path;
		if (path.length == 0)
			throw new Exception("Scope path is empty for node creation.");

		var expression:Expression = null;
		var new_scope = new Scope();
		if (path.length == 1 && path[0] == 'new') {
			//new_scope_definition.only_new = true;
			expression = convert_statement(source.expression, new_scope);
			return new Scope_Expression(new_scope, [expression]);
			//return new Scope_Expression(expression, new_scope_definition);
		}

		var rail = railway.resolve_rail_path(path);// hub.schema.root_namespace.get_namespace(path);
		//var trellis = hub.schema.get_trellis(path[path.length - 1], namespace);

		//if (rail != null) {
			new_scope.rail = rail;
			expression = convert_statement(source.expression, new_scope);
			//return new Scope_Expression(expression, new_scope_definition);
			return new Scope_Expression(new_scope, [expression]);
		//}
		//else {
			//throw new Exception("Not implemented.");
			////var symbol = scope.find(source.path);
			////new_scope_definition.symbol = symbol;
			////new_scope_definition.trellis = symbol.get_trellis();
			////expression = convert_statement(source.expression, new_scope_definition);
			////return new Node_Scope(expression, new_scope_definition);
		//}
	}

	//function weight(source:Dynamic, scope:Scope):Expression {
		//return new Set_Weight(source.weight, convert_statement(source.statement, scope));
  //}

  function create_array(source:Dynamic, scope:Scope):Expression {
		var expressions:Array<Dynamic> = source.expressions;
		return new Block(expressions.map(function(e) return convert_expression(e, null, scope)));
  }

  function create_lambda(source:Dynamic, scope:Scope, constraint_expressions:Array<Expression>):Expression {
		var expressions:Array<Dynamic> = source.expressions;
		var new_scope = new Scope(scope);
		var parameters:Array<String> = source.parameters;
		var i = 0;
		for (parameter in parameters) {
			var expression = constraint_expressions[i];
			var path = Parse.normalize_path(expression);
			new_scope.variables[parameter] = path[path.length - 1].get_signature();
			++i;
		}

		return new metahub.meta.types.Lambda(new_scope, parameters.map(function(p) return new Parameter(p, null))
			, expressions.map(function(e) return convert_statement(e, new_scope))
		);
  }

  function function_scope(source:Dynamic, scope:Scope):Expression {
		var expression = convert_expression(source.expression, null, scope);
		var path:Path = cast expression;
		var token = path.children[path.children.length - 2];
		return new Function_Scope(expression,
			cast create_lambda(source.lambda, scope, [ token, token ])
		);
  }

}