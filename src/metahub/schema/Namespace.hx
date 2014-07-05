package metahub.schema;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Namespace
{
	public var name:String;
	public var fullname:String;
	public var trellises = new Map<String, Trellis>();
	public var children = new Map<String, Namespace>();
	public var parent:Namespace;
	
	public function new(name:String, fullname:String) 
	{
		this.name = name;
		this.fullname = fullname;
	}
	
}