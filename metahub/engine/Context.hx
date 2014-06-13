package engine;
import schema.Property;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Context {
	public var entry_port:Port;

	public function new(entry_port:Port) {
		this.entry_port = entry_port;
	}

}