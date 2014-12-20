package metahub.imperative.types ;
import metahub.logic.schema.Tie;

/**
 * @author Christopher W. Johnson
 */

class Expression {
	public var type:Expression_Type;
	public var child:Expression = null;
	
	private function new(type:Expression_Type) {
		this.type = type;
	}
}
//typedef Expression = {
	//type:Expression_Type,
	//?value:Dynamic,
	//?child:Expression,
	//?name:String,
	//?args:Array<Dynamic>,
	//?path:Array<Dynamic>,
	//?tie:Tie,
	//?is_platform_specific:Bool
//}