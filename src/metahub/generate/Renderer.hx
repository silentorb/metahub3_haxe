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
		return this;
	}

	public function indent() {
		++depth;
		indentation += "\t";
		return this;
	}

	public function unindent() {
		--depth;
		indentation = indentation.substring(0, indentation.length - 1);
		return this;
	}

	public function add(text:String) {
		content += text;
		return this;
	}

	public function newline(amount:Int = 1) {
		var i = 0;
		while(i++ < amount) {
			content += "\n";
		}
		return this;
	}

	public function finish() {
		var result = content;
		content = "";
		depth = 0;
		indentation = "";
		return result;
	}

}