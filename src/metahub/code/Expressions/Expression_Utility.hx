package metahub.code.expressions;
import metahub.engine.Context;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Expression_Utility{

	public static function resolve(expression:Expression, scope:Scope):Dynamic {
		var port = expression.to_port(scope, null, null);
    return port.get_node_value(new Context(null, scope.hub));
	}

}