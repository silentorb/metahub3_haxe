package metahub.debug;

import metahub.debug.query.Explorer;

/**
 * ...
 * @author Christopher W. Johnson
 */
class History {

	//public var print_logs = false;
	public var only_on_start = true;
	var is_start = true;
	public var entries = new Array<Entry>();
	var current:Entry = null;
	public var stack = new Array<Entry>();

	public function new() {

	}

	public function add(entry:Entry) {
		if (only_on_start && !is_start)
			return;

		if (entries.length == 0)
			throw new Exception("At least one entry story must be initialized");

		entry.parent = current;
		current.children.push(entry);
		current = entry;
	}

	public function new_tree() {
		if (only_on_start && !is_start)
			return;

		if (stack.length > 1)
			throw new Exception("History leak:  Tried to create new tree when previous stack was not unset.");

		current = new Entry('Root');
		entries.push(current);
		stack = [ current ];
	}

	public function start_anchor() {
		stack.push(current);
	}

	public function end_anchor() {
		current = stack.pop();
	}

	public function back_to_anchor() {
		if (only_on_start && !is_start)
			return;

		//if (current == null)
			//throw new Exception("Cannot end branch. There is no active history tree.");

		current = stack[stack.length - 1];
		if (current == null)
			throw new Exception("Current history entry cannot be null.");
	}

	public function pop() {
		if (only_on_start && !is_start)
			return;

		current = stack.pop().parent;
		if (current == null)
			throw new Exception("Current history entry cannot be null.");
	}

	public function start_finished(){
		is_start = false;
	}

	public function create_explorer() {
		return new Explorer(this);
	}

}