package metahub.imperative.schema ;

/**
 * @author Christopher W. Johnson
 */

typedef Property_Hooks = {
	?set_post:Dynamic
}

typedef Property_Addition = {
	?hooks:Property_Hooks
}