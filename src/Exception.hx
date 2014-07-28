package ;
import haxe.format.JsonParser;

#if (nodejs || html5)

extern class Error {
	public function new(string:String, status:Int = 0);
}
typedef Exception = Error;

//class Exception extends Error {
//	public var code:Dynamic;
//
//	public function new(message:String, code:Dynamic = null) {
//		super(message);
//		this.code = code;
//	}
//}

#elseif php

typedef Exception = php.HException;
//extern class Exception {
//public function new(string:String, code:Dynamic = null);
//}
//
#else

class Exception {
	public var message:String;
	public var code:Dynamic;

	public function new(message:String, code:Dynamic = null) {
		trace(message);
		this.message = message;
		this.code = code;
	}
}

#end