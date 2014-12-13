package metahub.imperative.types ;

/**
 * @author Christopher W. Johnson
 */

 
class Flow_Control extends Expression {
	public var name:String;
	public var condition:Condition;
	public var children:Array<Expression>;
	
	public function new(name:String, condition:Condition, children:Array<Expression>) {
		super(Expression_Type.flow_control);
		this.name = name;
		this.condition = condition;
		this.children = children;
	}
	
}
//typedef Flow_Control = {
	//type:Expression_Type,
	//name:String,
	//condition:Condition,
	//statements:Array<Dynamic>,
//}