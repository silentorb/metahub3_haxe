package metahub;
import metahub.generate.Generator;

class Main {

  public var hub:Hub;

  public static function main() {

#if nodejs
  untyped __js__('if (haxe.Log) haxe.Log.trace = function(data, info)
  {
  if (info.customParams && info.customParams.length > 0)
    console.log.apply(this, [data].concat(info.customParams))
  else
    console.log(data)

  }');
#end

		//var hub = new Hub();
		//hub.load_schema_from_file('test/schema.json');
		//var code = sys.io.File.getContent('test/general.mh');
    //var result:metahub.parser.Match = cast hub.parse_code(code);
		//var data = result.get_data();
  }
}