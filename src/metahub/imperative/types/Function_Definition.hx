package metahub.imperative.types ;
import metahub.imperative.schema.Dungeon;
import metahub.logic.schema.Rail;
import metahub.schema.Kind;
import metahub.logic.schema.Signature;

/**
 * @author Christopher W. Johnson
 */

class Function_Definition extends Anonymous_Function {
	public var name:String;
	public var dungeon:Dungeon;
	public var rail:Rail;
	
	public function new(name:String, dungeon:Dungeon, parameters:Array<Parameter>, expressions:Array<Expression>, return_type:Signature = null) {
		super(parameters, expressions, return_type);		
		this.name = name;
		this.dungeon = dungeon;
		this.rail = dungeon.rail;
		if (rail != null)
			dungeon.functions.push(this);
	}
}
