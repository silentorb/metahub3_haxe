package metahub.render.targets.haxe ;
import metahub.imperative.schema.Railway;
import metahub.Hub;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Haxe_Target extends Target{

	public function new(railway:Railway) {
		super(railway);
	}

	override public function run(statement, output_folder:String) {
		for (region in railway.regions){
			for (rail in region.rails) {
				var trellis = rail.trellis;
				//trace(trellis.namespace.fullname);
				var namespace = Generator.get_namespace_path(rail.region);
				var dir = output_folder + "/" + namespace.join('/');
				Utility.create_folder(dir);

				var text = "package " + namespace.join('.')
					+ ";\n\nclass " + trellis.name + " {\n\n}\n\nclass "
					+ trellis.name + "_Actions {\n\n}\n";

				Utility.create_file(dir + "/" + trellis.name + ".hx", text);
			}
		}
	}
}