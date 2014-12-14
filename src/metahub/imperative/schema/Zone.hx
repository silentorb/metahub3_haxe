package metahub.imperative.schema;
import metahub.imperative.types.Expression;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Zone
{
	var divisions = new Array<Array<Expression>>();
	var target:Array<Expression>;
	var blocks:Map<String, Array<metahub.imperative.types.Expression>>;
	
	public function new(target:Array<Expression>, blocks) 
	{
		this.target = target;
		this.blocks = blocks;
	}
		
	public function divide(block_name:String = null, division:Array<Expression> = null) {
		division = add_zone(division);
		if (block_name != null)
			blocks[block_name] = division;		
			
		return division;
	}
	
	public function add_zone(zone:Array<Expression> = null):Array<Expression> {
		if (zone == null)
			zone = [];
			
		divisions.push(zone);
		return zone;
	}
	
	public function flatten() {
		for (division in divisions) {
			for (expression in division) {
				target.push(expression);
			}
		}
		
		divisions = new Array<Array<Expression>>();
	}
	
}