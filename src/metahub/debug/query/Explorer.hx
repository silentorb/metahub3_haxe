package metahub.debug.query;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Explorer
{
	var history:History;
	var range:Int = -1;
	var filters = new Array<Filter>();

	public function new(history:History)
	{
		this.history = history;
	}

	public function set_range(value:Int):Explorer {
		range = value;
		return this;
	}

	public function add_filter(filter:Filter):Explorer {
		filters.push(filter);
		return this;
	}

	function get_clusters():Array<Cluster> {
		if (filters.length > 0) {
			//for (filter in filters) {
				//
			//}

			var filter = filters[0];
			var result = new Array<Cluster>();
			for (root in history.entries) {
				filter_tree(root, filter, result);
			}

			return result;
		}
		else {
			return history.entries.map(function(e) { return new Cluster(e, range, range); });
		}
	}

	function filter_tree(entry:Entry, filter:Filter, result:Array<Cluster>) {
		if (Filter_Tools.match(entry, filter)) {
			result.push(new Cluster(entry, range, range));
		}

		for (child in entry.children) {
			filter_tree(child, filter, result);
		}
	}

	public function render():String {
		var clusters = get_clusters();
		return clusters.map(function(e) { return render_cluster(e, range); } ).join("\n\n");
	}

	public function render_cluster(cluster:Cluster, falloff = -1):String {
		var depth = cluster.get_reverse_depth();
		return process_entry_reverse(cluster.entry.parent, depth - 1)
			+ process_entry(cluster.entry, depth, cluster.range_up);
	}

	public function process_entry_reverse(entry:Entry, depth:Int):String {
		if (entry == null || depth == 0)
			return '';

		return process_entry_reverse(entry.parent, depth - 1)
			+ render_entry(entry, depth);
	}

	public function process_entry(entry:Entry, depth:Int, falloff = -1):String {
		var output = render_entry(entry, depth);
		if (falloff != 0) {
			if (entry.children.length > 0) {
				for(child in entry.children) {
					output += process_entry(child, depth + 1, falloff - 1);
				}
			}
		}

		return output;
	}

	public function render_entry(entry:Entry, depth:Int):String {
		var tabbing = " ";
		var padding = "";
		for (i in 0...depth) {
			padding += tabbing;
		}

		var message = entry.message != null && entry.message.length > 0 ? entry.message : '(none)';
		var output = "\n" + padding + entry.id + ' ' + message + ' [ ';
		if (entry.input != null)
			output += '#' + Reflect.field(entry.input, 'id') + " " + Hub.get_node_label(entry.input);

		output += ', ';
		if (entry.output != null)
			output += '#' + Reflect.field(entry.output, 'id') + " " + Hub.get_node_label(entry.output);

		if (entry.context != null)
			output += " (" + entry.context.trellis.name + " " + entry.context.id + ")";

		output += ' ]';
		return output;
	}

}