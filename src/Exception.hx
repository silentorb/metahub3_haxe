package ;

#if (nodejs || html5)

//extern class Error {
//public function new(string:String);
//}
//typedef Exception = Error;

class Exception extends js.Error {
	public var code:Dynamic;
	
	public function new(message:String, code:Dynamic = null) {
		super();
		this.message = message;
		this.code = code;
	}
}

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
		this.message = message;
		this.code = code;
	}
}

#end