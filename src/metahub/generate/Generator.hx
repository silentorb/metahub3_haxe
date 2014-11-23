package metahub.generate;
import metahub.generate.targets.Cpp_Target;
import metahub.generate.targets.Haxe_Target;
import metahub.generate.targets.Target;
import metahub.Hub;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */
@:expose class Generator {

	var hub:Hub;

	public function new(hub:Hub) {
		this.hub = hub;
	}

	public function run(statement, target_name:String, output_folder:String) {
		Utility.clear_folder(output_folder);

		var target:Target = null;

		switch(target_name) {
			case "cpp":
				target = new Cpp_Target(hub);

			case "haxe":
				target = new Haxe_Target(hub);
		}

		target.run(statement, output_folder);
	}

	public static function get_namespace_path(namespace:Namespace):Array<String> {
		var tokens = [];
		while(namespace != null && namespace.name != 'root') {
			tokens.unshift(namespace.name);
			namespace = namespace.parent;
		}

		return tokens;
	}

}