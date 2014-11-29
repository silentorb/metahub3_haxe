package metahub.schema;
import metahub.code.functions.Function_Library;
import metahub.code.functions.Functions;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Namespace
{
	public var name:String;
	public var fullname:String;
	public var trellises = new Map<String, Trellis>();
	public var function_library:Function_Library;
	public var children = new Map<String, Namespace>();
	public var parent:Namespace;
	public var additional = new Map<String, Dynamic>();
	public var is_external = false;

	public function new(name:String, fullname:String, function_library:Function_Library = null)
	{
		this.name = name;
		this.fullname = fullname;
		this.function_library = function_library;
	}

	public function has_name(name:String):Bool {
		return trellises.exists(name);
	}

	public function get_namespace(path:Array<String>):Namespace {
		var current_namespace = this;
		var i = 0;
		for (token in path) {
			if (current_namespace.children.exists(token)) {
				current_namespace = current_namespace.children[token];
			}
			else if (current_namespace.has_name(token) && i == path.length - 1) {
				return current_namespace;
			}
			else {
				return parent != null
					? parent.get_namespace(path)
					: null;
			}
			++i;
		}

		return current_namespace;
	}

}