package metahub.generate;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Renderer{

	var depth:Int = 0;
	var content:String = "";
	var indentation:String = "";

	public function new() {

	}

	public function line(text:String) {
		content += indentation + text + "\n";
	}

	public function indent() {
		++depth;
		indentation += "\t";
	}

	public function undent() {
		--depth;
		indentation = indentation.substring(0, indentation.length - 1);
	}

	public function add(text:String) {
		content += text;
	}

	public function get_content() {
		return content;
	}

}