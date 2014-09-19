package metahub.debug;

/**
 * ...
 * @author Christopher W. Johnson
 */
class History {

	//public var print_logs = false;
	public var only_on_start = true;
	var is_start = true;
	var entries = new Array<Entry>();
	var current:Entry = null;
	public var stack = new Array<Entry>();

	public function new() {

	}

	public function add(entry:Entry, on_stack:Bool = false) {
		if (only_on_start && !is_start)
			return;

		if (entries.length == 0)
			throw new Exception("At least one entry story must be initialized");

		entry.parent = current;
		current.children.push(entry);
		current = entry;
		if (on_stack)
			stack.push(entry);
	}

	public function new_tree() {
		if (only_on_start && !is_start)
			return;

		if (stack.length > 1)
			throw new Exception("History leak:  Tried to create new tree when previous stack was not unset.");

		current = new Entry();
		entries.push(current);
		stack = [ current ];
	}

	public function back() {
		if (only_on_start && !is_start)
			return;

		if (current == null)
			throw new Exception("Cannot end branch. There is no active history tree.");

		if (current.parent == null)
			throw new Exception("Cannot end branch. Current entry has no parent.");

		current = stack[stack.length - 1];
	}

	public function pop() {
		if (only_on_start && !is_start)
			return;

		if (current == null)
			throw new Exception("Cannot end branch. There is no active history tree.");

		if (current.parent == null)
			throw new Exception("Cannot end branch. Current entry has no parent.");

		current = stack.pop().parent;
	}

	public function start_finished(){
		is_start = false;
	}

	public function render():String {
		return entries.map(function(e) { return render_entry(e); } ).join("\n");
	}

	public function render_entry(entry:Entry, depth:Int = 0):String {
		var tabbing = " ";
		var padding = "";
		for (i in 0...depth) {
			padding += tabbing;
		}

		var message = entry.message != null && entry.message.length > 0 ? entry.message : '(none)';
		var result = "\n" + padding + message + ' [ ';
		if (entry.input != null)
			result += '#' + Reflect.field(entry.input, 'id') + " " + Hub.get_node_label(entry.input);

		result += ', ';
		if (entry.output != null)
			result += '#' + Reflect.field(entry.output, 'id') + " " + Hub.get_node_label(entry.output);

		result += ' ]';
		if (entry.children.length > 0) {
			for(child in entry.children) {
				result += render_entry(child, depth + 1);
			}
		}

		return result;
	}
}