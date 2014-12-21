package metahub.imperative.schema;
import metahub.logic.schema.Tie;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Lair
{
	public var tie:Tie;
	public var dungeon:Dungeon;
	public var name:String;
	
	public function new(tie:Tie, dungeon:Dungeon) 
	{
		this.tie = tie;
		this.dungeon = dungeon;
		this.name = tie.name;
	}
	
}