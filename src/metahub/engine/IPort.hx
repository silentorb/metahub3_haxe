package metahub.engine;

import metahub.code.Functions;
import metahub.schema.Kind;
import metahub.schema.Types;
import metahub.engine.Constraint_Operator;

interface IPort {
  var connections:Array<IPort>;
  //var parent:INode;
  function connect(other:IPort):Void;
  //var action(get, set):Functions;
  function get_value(context:Context = null):Dynamic;
  function set_value(v:Dynamic, context:Context = null):Dynamic;
	function get_type():Kind;
}
