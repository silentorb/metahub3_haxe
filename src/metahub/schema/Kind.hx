package metahub.schema;

/**
 * @author Christopher W. Johnson
 */

 @:enum
abstract Kind(Int) {
	var void = 0;
  var int = 1;
  var string = 2;
  var reference = 3;
  var list = 4;
  var float = 5;
  var bool = 6;
	var unknown = 7;
}
