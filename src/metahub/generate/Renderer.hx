package metahub.generate;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Renderer{

	var depth:Int = 0;
	//var content:String = "";
	var indentation:String = "";

	public function new() {

	}

	public function line(text:String):String {
		return indentation + text + "\n";
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

	//public function add(text:String) {
		//content += text;
		//return this;
	//}

	public function newline(amount:Int = 1):String {
		var i = 0;
		var result = "";
		while(i++ < amount) {
			result += "\n";
		}
		return result;
	}

	public function finish() {
		//content = "";
		depth = 0;
		indentation = "";
	}
	
	public function pad(content:String) {
		return content == ""
		? content
		: newline() + content;
	}

}