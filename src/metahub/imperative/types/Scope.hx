package metahub.imperative.types ;
import metahub.logic.schema.Signature;

/**
 * @author Christopher W. Johnson
 */

typedef Scope =
{
	//type:Expression_Type,
	variables:Map<String, Signature>,
	//children:Array<Scope>,
	//statements:Array<Dynamic>
}