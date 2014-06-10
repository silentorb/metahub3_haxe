package code.symbols;
import code.references.Reference;

/**
 * @author Christopher W. Johnson
 */

interface ISchema_Symbol extends Symbol {
	function create_reference(path:Array<String>):Reference<ISchema_Symbol>;

}