package engine;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Reference_Port extends Single_Port implements IPort {

	var value:Node;

	public function new() {

	}

  public function add_dependency(other:IPort) {
    this.dependencies.push(other);
    other.dependents.push(this);
  }

	public function get_other_node():Node {
		return value;
	}
}