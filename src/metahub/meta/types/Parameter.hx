package metahub.meta.types ;
import metahub.logic.schema.Signature;

/**
 * @author Christopher W. Johnson
 */

class Parameter {
	public var name:String;
	public var signature:Signature;

	public function new(name:String, signature:Signature = null) 
	{
		this.name = name;
		this.signature = signature;
	}
}