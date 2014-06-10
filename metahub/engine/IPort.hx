package engine;

import code.Functions;

interface IPort {
  var dependencies:Array<IPort>;
  var dependents:Array<IPort>;
  //var parent:INode;
  function add_dependency(other:IPort):Void;
  //var action(get, set):Functions;
  function get_value():Dynamic;
}
