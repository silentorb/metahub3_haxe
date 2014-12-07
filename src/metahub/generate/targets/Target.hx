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
	
	public function line(text:String):String {
		return render.line(text);
	}

	public function indent() {
		return render.indent();
	}

	public function unindent() {
		return render.unindent();
	}

	public function newline(amount:Int = 1):String {
		return render.newline(amount);
	}

}