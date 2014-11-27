package metahub.generate;
import metahub.Hub;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Railway{

	public var rails = new Map<String, Rail>();

	public function new(hub:Hub) {
		for (trellis in hub.schema.trellises) {
			rails[trellis.name] = new Rail(trellis);
		}
	}

}