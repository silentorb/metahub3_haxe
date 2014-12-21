package metahub.logic.schema;

/**
 * @author Christopher W. Johnson
 */

interface IRail 
{
	function get_tie_or_null(name:String):ITie;
	function get_tie_or_error(name:String):ITie;
}