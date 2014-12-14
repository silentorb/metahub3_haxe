package metahub.render ;
import metahub.imperative.schema.Railway;
import metahub.render.Renderer;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Target{
	var railway:Railway;
	var render = new Renderer();
	var line_count = 0;
	
	public function new(railway:Railway) {
		this.railway = railway;
	}

	public function run(output_folder:String) {

	}
	
	public function line(text:String):String {
		++line_count;
		return render.line(text);
	}

	public function indent() {
		return render.indent();
	}

	public function unindent() {
		return render.unindent();
	}

	public function newline(amount:Int = 1):String {
		++line_count;
		return render.newline(amount);
	}
	
	public function pad(content:String) {
		return content == ""
		? content
		: newline() + content;
	}

}