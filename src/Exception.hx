package ;

#if (nodejs || html5)

extern class Error {
public function new(string:String);
}
typedef Exception = Error;

#elseif php

typedef Exception = php.HException;
//extern class Exception {
//public function new(string:String, code:Dynamic = null);
//}
//
#else

typedef Exception  = String;

#end