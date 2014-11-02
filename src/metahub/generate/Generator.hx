package metahub.generate;
import metahub.Hub;

/**
 * ...
 * @author Christopher W. Johnson
 */
@:expose class Generator {

	var hub:Hub;

	public function new(hub:Hub) {
		this.hub = hub;
	}

	public function run(statement, output_folder:String) {

		for (trellis in hub.schema.trellises) {
			var text = "package ;\n\nclass " + trellis.name + " {\n\n}\n\nclass "
			+ trellis.name + "_Actions {\n\n}\n";
			Utility.create_file("test/gen/output/" + trellis.name + ".hx", text);
		}


	}

}