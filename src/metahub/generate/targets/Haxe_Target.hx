package metahub.generate.targets;
import metahub.Hub;
import metahub.schema.Namespace;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Haxe_Target extends Target{

	public function new(hub:Hub) {
		super(hub);
	}

	override public function run(statement, output_folder:String) {
		for (trellis in hub.schema.trellises) {
			//trace(trellis.namespace.fullname);
			var namespace = Generator.get_namespace_path(trellis.namespace);
			var dir = output_folder + "/" + namespace.join('/');
			Utility.create_folder(dir);

			var text = "package " + namespace.join('.')
				+ ";\n\nclass " + trellis.name + " {\n\n}\n\nclass "
				+ trellis.name + "_Actions {\n\n}\n";

			Utility.create_file(dir + "/" + trellis.name + ".hx", text);
		}
	}
}