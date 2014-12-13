package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

class Function_Call extends Expression {
	public var name:String;
	public var args:Array<Dynamic>;
	public var is_platform_specific:Bool;
	
	public function new(name:String, args:Array<Dynamic> = null, is_platform_specific:Bool = false) {
		super(Expression_Type.function_call);
		this.name = name;
		this.is_platform_specific = is_platform_specific;
		this.args = args != null ? args : [];
	}
}
//typedef Function_Call = {
		//type:String,
		//name:String,
		//caller:String,
		//args:Array<Dynamic>,
		//is_platform_specific:Bool
//}