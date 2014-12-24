package metahub.meta.types;
import metahub.logic.schema.Signature;
import metahub.schema.Kind;

/**
 * @author Christopher W. Johnson
 */

class Array_Expression extends Expression{
	public var children:Array<Expression>;

	public function new(children:Array<Expression> = null) {
		this.children = children != null
		 ? children : [];
		
		super(Expression_Type.array);
	}
	
	override public function get_signature():Signature 
	{
		return { type: Kind.list, rail: null };
	}
}