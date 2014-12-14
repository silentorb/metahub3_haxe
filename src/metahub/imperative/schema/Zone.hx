package metahub.imperative.schema;
import metahub.imperative.types.Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Zone
{
	//var zone_map = new Map<String, Array<Expression>>();
	var zones = new Array<Array<Expression>>();
	var target:Array<Expression>;
	
	public function new(target:Array<Expression>) 
	{
		this.target = target;
	}
	
	public function add_zone(/*path:String, */zone:Array<Expression> = null):Array<Expression> {
		if (zone == null)
			zone = [];
			
		//zone_map[path] = zone;
		zones.push(zone);
		return zone;
	}
	
	public function flatten() {
		for (zone in zones) {
			for (expression in zone) {
				target.push(expression);
			}
		}
		
		//zone_map = new Map<String, Array<Expression>>();
		zones = new Array<Array<Expression>>();
	}
	
}