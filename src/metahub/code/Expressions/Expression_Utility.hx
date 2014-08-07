package metahub.code.expressions;
import metahub.engine.Context;
import metahub.engine.Empty_Context;
import metahub.engine.Node_Context;


/**
 * ...
 * @author Christopher W. Johnson
 */
class Expression_Utility{

	public static function resolve(expression:Expression, target_type:Type_Signature, scope:Scope):Dynamic {
		var node_signature = Type_Network.analyze(expression, target_type, scope);
		return expression.get_value(scope, node_signature);
		//var port = expression.to_port(scope, null, node_signature);
    //return port.get_node_value(new Empty_Context(scope.hub));
	}

}