package metahub.debug;
import metahub.code.nodes.INode;
import metahub.engine.Node;
import metahub.schema.Property;

/**
 * @author Christopher W. Johnson
 */

class Entry {
	public var message:String = '';
	public var input:INode;
	public var output:INode;
	public var value:Dynamic;
	public var property:Property;
	public var children = new Array<Entry>();
	public var parent:Entry = null;
	public var id:Int;
	public var context:Node;

	static var counter = -1;
	
	public function new(message:String = '') {
		this.message = message;
		id = ++counter;
	}
}