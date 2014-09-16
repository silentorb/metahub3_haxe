package metahub.code.nodes;
import metahub.engine.Context;

/**
 * @author Christopher W. Johnson
 */

interface IToken_Node {
  public function resolve_token(value:Dynamic, is_last:Bool):Resolution;
	public function resolve_token_reverse(value:Dynamic, previous:Dynamic):Resolution;
	public function set_token_value(value:Dynamic, previous:Dynamic, context:Context):Void;
}