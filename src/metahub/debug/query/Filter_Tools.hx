package metahub.debug.query;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Filter_Tools{

	static public function match(entry:Entry, filter:Filter):Bool {
		if (filter.path == 'node.id') {
			return filter.value == get_value(entry, 'input.id')
			|| filter.value == get_value(entry, 'output.id');
		}
		return filter.value == get_value(entry, filter.path);
	}

	static function get_value(entry:Entry, path:String) {
		switch (path) {
			case 'input.id':
				return entry.input == null
					? null
					: Reflect.field(entry.input, 'id');

			case 'output.id':
				return entry.output == null
					? null
					: Reflect.field(entry.output, 'id');

			default:
				throw new Exception("Invalid entry path: " + path + ".");
		}
	}

}