package metahub.debug;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Explorer
{
	public function new() 
	{
		
	}
	
	public function render(history:History):String {
		return history.entries.map(function(e) { return render_entry(e); } ).join("\n");
	}

	public function render_entry(entry:Entry, depth:Int = 0):String {
		var tabbing = " ";
		var padding = "";
		for (i in 0...depth) {
			padding += tabbing;
		}

		var message = entry.message != null && entry.message.length > 0 ? entry.message : '(none)';
		var result = "\n" + padding + entry.id + ' ' + message + ' [ ';
		if (entry.input != null)
			result += '#' + Reflect.field(entry.input, 'id') + " " + Hub.get_node_label(entry.input);

		result += ', ';
		if (entry.output != null)
			result += '#' + Reflect.field(entry.output, 'id') + " " + Hub.get_node_label(entry.output);
			
		if (entry.context != null)
			result += " (" + entry.context.trellis.name + " " + entry.context.id + ")";

		result += ' ]';
		if (entry.children.length > 0) {
			for(child in entry.children) {
				result += render_entry(child, depth + 1);
			}
		}

		return result;
	}
}