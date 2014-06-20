package metahub;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Macros{

	macro static public function insert_file_as_string(path:String):Expr {
    // I don't expect you to have a license file, so let's even create it if it
    // does not exist yet:
    //if (!sys.FileSystem.exists('license.txt'))
      //sys.io.File.saveContent("license.txt", "LICENSE: Whatever license haxe.org manual has");

    var now_str = sys.io.File.getContent(path);

    // var result = Context.makeExpr(now_str, Context.currentPos());
    // shorter writing:
    var result = macro $v{now_str}; // haxe 3.0: $v(now_str);

    // Example 3) how to debug expressions
    // trace(result); // have a look at the syntax tree haxe has created using the macro keyword
    // sometimes trace fails, throw seems to work always
    // tinkerbell even provides a 'expr to haxe code' feature:
    // tink.macro.tools.Printer.print(result);
    return result;
  }
}