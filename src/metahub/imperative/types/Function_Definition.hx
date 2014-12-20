package metahub.imperative.types ;
import metahub.imperative.schema.Dungeon;
import metahub.logic.schema.Rail;
import metahub.schema.Kind;

/**
 * @author Christopher W. Johnson
 */

class Function_Definition extends Expression {
	public var name:String;
	public var parameters:Array<Parameter>;
	public var block:Array<Expression>;
	public var return_type:Signature;
	public var dungeon:Dungeon;
	public var rail:Rail;
	
	public function new(name:String, dungeon:Dungeon, parameters:Array<Parameter>,block:Array<Expression>,	return_type:Signature = null) {
		super(Expression_Type.function_definition);
		this.name = name;
		this.parameters = parameters;
		this.block = block;
		this.return_type = return_type == null
		? { type: Kind.none }
		: return_type;
		
		this.dungeon = dungeon;
		this.rail = dungeon.rail;
		if (rail != null)
			dungeon.functions.push(this);
	}
}
