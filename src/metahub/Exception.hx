package metahub;

#if (nodejs || html5)

extern class Error {
public function new(string:String);
}
typedef Exception = Error;

#else

typedef Exception  = String;

#end