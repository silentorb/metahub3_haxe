package metahub.imperative.types ;
import metahub.logic.schema.Rail;

/**
 * @author Christopher W. Johnson
 */

 class Instantiate extends Expression {
	public var rail:Rail;
	
	public function new(rail:Rail) {
		super(Expression_Type.instantiate);
		this.rail = rail;
	}
}

//typedef Instantiate =
//{
	//type:String,
	//rail:Rail
//}