package metahub.schema;

/**
 * @author Christopher W. Johnson
 */

 @:enum
abstract Kind(Int) {
	var any = 0;
  var int = 1;
  var string = 2;
  var reference = 3;
  var list = 4;
  var float = 5;
  var bool = 6;
	var unknown = 7;
	/*
	static var name_map:Map <String, Kind>; 
	static public function from_string(text:String):Kind {
		if (name_map == null) {
			name_map = new Map <String, Kind> ();
		}
		
		return Kind.any;
	}*/
}
