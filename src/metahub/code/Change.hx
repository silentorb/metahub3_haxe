package metahub.code;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Change
{
	//public var status:Change_Status;
	public var value:Dynamic;
	
	public function new(value:Dynamic) //, status:Change_Status = Change_Status.active) 
	{
		this.value = value;
		//this.status = status;
	}
	
}