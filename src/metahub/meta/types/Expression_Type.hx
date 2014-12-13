package metahub.meta.types ;

/**
 * @author Christopher W. Johnson
 */

 @:enum
abstract Expression_Type(Int) {
	// Expressions
  var literal = 1;
  var property = 2;
  var variable = 3;
  var function_call = 4;
	var instantiate = 5;
	var parent_class = 6;

	// Statements
	var namespace = 100;
	var class_definition = 101;
	var function_definition = 102;
	var flow_control = 103;
	var assignment = 104;
	var declare_variable = 105;
	var scope = 106;

}