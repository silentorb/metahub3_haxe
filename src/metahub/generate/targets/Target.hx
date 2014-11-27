package metahub.generate.targets;
import metahub.generate.Railway;
import metahub.generate.Renderer;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Target{
	var railway:Railway;
	var render = new Renderer();

	public function new(railway:Railway) {
		this.railway = railway;
	}

	public function run(statement, output_folder:String) {

	}

}