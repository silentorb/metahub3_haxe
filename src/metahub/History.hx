package metahub;

/**
 * ...
 * @author Christopher W. Johnson
 */
class History {

	public var print_logs = false;

	public function new() {

	}

	public function log(message:String) {
		if (print_logs)
			trace(message);
	}

}