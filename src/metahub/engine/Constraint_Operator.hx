package metahub.engine;

/**
 * @author Christopher W. Johnson
 */

@:enum
abstract Constraint_Operator(Int) {
	var equals = 0;
  var lesser_than = 1;
  var greater_than = 2;
  var lesser_than_or_equal_to = 3;
  var greater_than_or_equal_to = 4;  
}
