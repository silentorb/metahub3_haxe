package metahub.engine;

/**
 * @author Christopher W. Johnson
 */

interface Signal_Node {
	function get_input(context:Context):Dynamic;
	function get_output(context:Context):Dynamic;

}