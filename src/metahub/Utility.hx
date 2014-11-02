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
  json = Nodejs.fs.readFileSync(url, { encoding: 'ascii' });
#else
    //throw new Exception("load_json() not supported for this compilation target.");
		json = sys.io.File.getContent(url);
#end

    return Json.parse(json);
  }

	public static function clear_folder(url:String) {
#if nodejs
	var walk = function(dir:String) {
		var children = Nodejs.fs.readDir(dir);
		for (child in children) {
			var stat = Nodejs.fs.statSync(child)
			if (stat && stat.isDirectory()) {
				walk(child);
				Nodejs.fs.rmdirSync(child);
			}
			else {
				Nodejs.fs.unlinkSync(child);
			}
		}
	}
	var files = Nodejs.fs.readDir(url);
	for
#else
	throw "Not supported.";
#end
	}

	public static function create_file(url:String, contents:String) {
#if nodejs
	Nodejs.fs.writeFileSync(url, cast contents );
#else
	throw "Not supported.";
#end

	}
}