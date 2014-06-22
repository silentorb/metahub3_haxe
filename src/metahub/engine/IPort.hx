package metahub.engine;

import metahub.code.Functions;
import metahub.schema.Kind;
import metahub.schema.Types;

interface IPort {
  var dependencies:Array<IPort>;
  var dependents:Array<IPort>;
  //var parent:INode;
  function add_dependency(other:IPort):Void;
  //var action(get, set):Functions;
  function get_value(context:Context = null):Dynamic;
  function set_value(v:Dynamic, context:Context = null):Dynamic;
	function get_type():Kind;
}