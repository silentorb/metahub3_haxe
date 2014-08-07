package metahub.code.statements;


/**
 * @author Christopher W. Johnson
 */

interface Statement {
    function resolve(scope:Scope):Dynamic;
}