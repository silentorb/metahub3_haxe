package metahub.logic.schema;

/**
 * @author Christopher W. Johnson
 */

interface ITie 
{
  function get_abstract_rail():IRail;
	var name:String;
	
	function fullname():String;	
}