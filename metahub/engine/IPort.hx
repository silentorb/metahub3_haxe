package engine;

import code.Functions;

interface IPort {
  var dependencies:Array<IPort>;
  var dependents:Array<IPort>;
  var node:Node;
  function add_dependency(other:IPort):Void;
  var action:Functions;

}
