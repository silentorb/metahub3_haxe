package metahub.logic.schema;
import metahub.meta.types.Function_Call;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Function_Info
{
	public var name:String;	
	public var versions = new Array<Function_Version>();

	public function new(name:String, versions:Array<Function_Version>) 
	{
		this.name = name;
		this.versions = versions;
	}
	
	public function add_version(input_signature:Signature, output_signature:Signature):Function_Version {
		var version = new Function_Version(input_signature, output_signature);
		versions.push(version);
		return version;
	}
	
	public function get_signature(call:Function_Call):Signature {
		var input = call.input.get_signature();
		for (version in versions) {
			if (match_signatures(version.input_signature, input))
				return version.output_signature;
		}
		
		throw new Exception("Could not find matching signature for function: " + name);
	}
	
	public static function match_signatures(first:Signature, second:Signature):Bool {
		if (first.type == Kind.reference || first.type == Kind.list)
			return first.type == second.type && (first.rail == null || first.rail == second.rail);
		else
			return first.type == second.type;
	}
	
}