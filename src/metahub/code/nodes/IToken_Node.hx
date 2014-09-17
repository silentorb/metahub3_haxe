package metahub.code.nodes;
import metahub.engine.Context;

/**
 * @author Christopher W. Johnson
 */

interface IToken_Node {
  public function resolve_token(change:Dynamic, is_last:Bool):Change;
	public function resolve_token_reverse(value:Dynamic, previous:Dynamic):Change;
	public function set_token_value(value:Dynamic, previous:Dynamic, context:Context):Void;
}