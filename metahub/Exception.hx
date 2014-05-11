
#if (nodejs || html5)

extern class Error {
public function new(string:String);
}
typedef Exception = Error;

#else

extern class Exception {
public function new(string:String);
}

#end