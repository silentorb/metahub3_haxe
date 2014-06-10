import Hub;

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
  }
}