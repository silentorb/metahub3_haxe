package metahub.code.symbols;
import metahub.code.references.Reference;
import metahub.schema.Trellis;

/**
 * @author Christopher W. Johnson
 */

interface ISchema_Symbol extends Symbol {
	//function create_reference(path:Array<String>):Reference<ISchema_Symbol>;
  function get_parent_trellis():Trellis;
}