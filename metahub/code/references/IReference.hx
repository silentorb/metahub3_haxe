package code.references;

/**
 * @author Christopher W. Johnson
 */

interface IReference {
	function resolve(scope:Scope):Dynamic;
}