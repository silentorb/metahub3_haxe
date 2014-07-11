package metahub.engine;

import metahub.code.Functions;
import metahub.schema.Kind;
import metahub.schema.Types;
import metahub.engine.Constraint_Operator;

interface IPort {
  var dependencies:Array<Relationship>;
  var dependents:Array<Relationship>;
  //var parent:INode;
  function add_dependency(other:IPort, operator:Constraint_Operator):Void;
  //var action(get, set):Functions;
  function get_value(context:Context = null):Dynamic;
  function set_value(v:Dynamic, context:Context = null):Dynamic;
	function get_type():Kind;
}
