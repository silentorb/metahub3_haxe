package metahub.imperative.schema;
import metahub.logic.schema.Range_Float;
import metahub.logic.schema.Tie;
import metahub.schema.Kind;
import metahub.imperative.types.*;

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
	
	public function customize_initialize(block:Array<Expression>) {
		for (r in tie.ranges) {
			var range:Range_Float = cast r;
			var reference = create_reference(range.path.length > 0 
				? new Path(cast range.path.map(function(t) return new Property_Expression(t)))
				: null
			);
			block.push(new Assignment(reference, "=", new Function_Call("rand", 
				[new Literal(range.min, {type: Kind.float }), new Literal(range.max, {type: Kind.float})], true)));		
		}
	}
	
	public function create_reference(child:Expression = null):Property_Expression {
		return new Property_Expression(tie, child);
	}
}