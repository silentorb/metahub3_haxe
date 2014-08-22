package metahub.code.functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
interface Comparison
{	
	function compare(first:Dynamic, second:Dynamic):Bool;
	function to_string():String;
}