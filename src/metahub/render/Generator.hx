package metahub.render ;
import metahub.render.targets.cpp.Cpp;
import metahub.render.targets.haxe.Haxe_Target;
import metahub.render.Target;
import metahub.Hub;
import metahub.logic.schema.Railway;
import metahub.logic.schema.Region;
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
	
	public function create_target(railway:Railway, target_name:String):Target {
		switch(target_name) {
			case "cpp":
				return new Cpp(railway);

			case "haxe":
				return new Haxe_Target(railway);
				
			default:
				throw new Exception("Unsupported target: " + target_name + ".");
		}		
	}

	public function run(target:Target, output_folder:String) {
		Utility.create_folder(output_folder);
		Utility.clear_folder(output_folder);
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