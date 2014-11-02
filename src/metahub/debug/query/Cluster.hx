package metahub.debug.query;
import metahub.debug.Entry;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Cluster {
	public var entry:Entry;
	public var range_up:Int;
	public var range_down:Int;
	public var entries = new Array<Entry>();

	public function new(entry:Entry, range_up:Int, range_down:Int) {
		this.entry = entry;
		this.range_up = range_up;
		this.range_down = range_down;
		update_entries();
	}

	public function get_reverse_depth() {
		var depth = entry.get_parent_depth();
		if (range_down > -1 && range_down < depth)
			depth = range_down;

		return depth;
	}

	function update_entries() {
		entries = new Array<Entry>();
		var depth = get_reverse_depth();

		process_entry_reverse(entry.parent, depth - 1, entries);
		process_entry(entry, depth, range_up, entries);
	}

	public function process_entry_reverse(entry:Entry, depth:Int, entries:Array<Entry>) {
		if (entry == null || depth == 0)
			return;

		process_entry_reverse(entry.parent, depth - 1, entries);
		entries.push(entry);
	}

	public function process_entry(entry:Entry, depth:Int, falloff, entries:Array<Entry>) {
		entries.push(entry);
		if (falloff != 0) {
			if (entry.children.length > 0) {
				for(child in entry.children) {
					process_entry(child, depth + 1, falloff - 1, entries);
				}
			}
		}
	}

}