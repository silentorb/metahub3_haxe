import haxe.Json;

#if nodejs
import js.Node in Nodejs;
#end

class Utility {

  public static function load_json(url:String):Dynamic {
    var json:String;
#if nodejs
  json = Nodejs.fs.readFileSync(url, { encoding: 'ascii' });
#else
    throw new Exception("load_json() not supported for this compilation target.");
#end

    return Json.parse(json);
  }

}