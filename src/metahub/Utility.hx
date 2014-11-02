package metahub;
import haxe.Json;

#if nodejs
import js.Node in Nodejs;
#end

class Utility {

  public static function load_json(url:String):Dynamic {
    var json:String;
#if html5
	throw new Exception("Not supported with html5.");
#elseif nodejs
  json = Nodejs.fs.readFileSync(url, { encoding: 'ascii' } );	
#else
    throw new Exception("load_json() not supported for this compilation target.");
		//json = sys.io.File.getContent(url);
#end

    return Json.parse(json);
  }

}