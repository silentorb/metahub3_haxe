package metahub.code;

/**
 * @author Christopher W. Johnson
 */

 @:enum
abstract Change_Status(Int) {
	var canceled = 0;
	var active = 1;
}
