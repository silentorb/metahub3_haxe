package metahub.logic.schema;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Function_Version {
	public var input_signature:Signature;
	public var output_signature:Signature;
	
	public function new(input:Signature, output:Signature) {
		input_signature = input;
		output_signature = output;
	}
}