package metahub.code.nodes;
import metahub.engine.Context;

/**
 * @author Christopher W. Johnson
 */

interface IToken_Node {
  public function resolve_token(value:Dynamic):Dynamic;
	public function resolve_token_reverse(value:Dynamic, previous:Dynamic):Dynamic;
	public function set_token_value(value:Dynamic, previous:Dynamic, context:Context):Void;
}