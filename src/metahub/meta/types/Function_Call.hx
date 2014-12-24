package metahub.meta.types;
import metahub.logic.schema.Railway;
import metahub.logic.schema.Signature;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Call extends Expression {
	public var name:String;
	public var input:Expression;
	public var signature:Signature;

	public function new(name:String, input:Expression, railway:Railway) {
		super(Expression_Type.function_call);
		this.name = name;
		if (input == null)
			throw new Exception("Function input cannot be null");
			
		this.input = input;
		signature = railway.root_region.functions[name].get_signature(this);
	}

	override public function get_signature():Signature 
	{
		return signature;
	}
}