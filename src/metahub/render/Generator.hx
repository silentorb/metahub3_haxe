package metahub.render ;
import metahub.render.targets.cpp.Cpp;
import metahub.render.targets.haxe.Haxe_Target;
import metahub.render.Target;
import metahub.Hub;
import metahub.imperative.schema.Railway;
import metahub.imperative.schema.Region;
import metahub.meta.types.Expression;
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

	public function run(railway:Railway, target_name:String, output_folder:String) {
		Utility.create_folder(output_folder);
		Utility.clear_folder(output_folder);
		var target:Target = null;

		switch(target_name) {
			case "cpp":
				target = new Cpp(railway);

			case "haxe":
				target = new Haxe_Target(railway);
				
			default:
				throw new Exception("Unsupported target: " + target_name + ".");
		}

		target.run(output_folder);
	}

	public static function get_namespace_path(region:Region):Array<String> {
		var tokens = [];
		while(region != null && region.name != 'root') {
			tokens.unshift(region.name);
			region = region.parent;
		}

		return tokens;
	}

}