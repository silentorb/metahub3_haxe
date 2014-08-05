package metahub.engine;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Empty_Context extends Context
{
	public function new(hub:Hub) {
		this.node = null;
		this.hub = hub;
	}
}