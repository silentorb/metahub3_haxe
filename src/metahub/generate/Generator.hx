package metahub.generate;
import metahub.code.expressions.Expression;
import metahub.generate.targets.cpp.Cpp_Target;
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

	public function run(statement:Expression, target_name:String, output_folder:String) {
		Utility.create_folder(output_folder);
		Utility.clear_folder(output_folder);
		var railway = new Railway(hub, hub.schema.additional[target_name]);
		railway.process(statement, hub.root_scope);
		var target:Target = null;

		switch(target_name) {
			case "cpp":
				target = new Cpp_Target(railway, hub.schema.additional['cpp']);

			case "haxe":
				target = new Haxe_Target(railway);
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