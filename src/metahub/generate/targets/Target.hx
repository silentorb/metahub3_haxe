package metahub.generate.targets;
import metahub.generate.Renderer;
import metahub.Hub;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Target{
	var hub:Hub;
	var render = new Renderer();

	public function new(hub:Hub) {
		this.hub = hub;
	}

	public function run(statement, output_folder:String) {

	}

}