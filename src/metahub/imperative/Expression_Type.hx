package metahub.imperative;

/**
 * @author Christopher W. Johnson
 */

 @:enum
abstract Expression_Type(Int) {
  var literal = 1;
  var property = 2;
  var variable = 3;
  var function_call = 4;
	var path = 100;
}