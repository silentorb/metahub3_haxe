package schema;
import engine.INode;
import engine.List_Port;
import engine.Node;

/**
 * @author Christopher W. Johnson
 */

typedef Property_Chain = Array<Property>;

class Property_Chain_Helper {
	public static function flip(chain:Property_Chain):Property_Chain {
		var result = new Property_Chain();
		var i = chain.length - 1;
		while (i >= 0) {
			if (chain[i].other_property != null)
				result.push(chain[i].other_property);

			--i;
		}
		return result;
	}

  public static function from_string(path:Array<String>, trellis:Trellis, start_index:Int = 0):Property_Chain {
    var result = new Property_Chain();
    for (x in start_index...path.length) {
      var property = trellis.get_property(path[x]);
      result.push(property);
      trellis = property.other_trellis;
    }

    return result;
  }

	//public static function resolve_node(chain:Property_Chain, node:Node) {
		//for (link in chain) {
			//var id = node.get_value(link.id);
			//node = node.hub.nodes[id];
		//}
//
		//return node;
	//}

	public static function perform(chain:Property_Chain, node:Node, action, start:Int = 0) {
		for (i in start...chain.length) {
			var link = chain[i];
			if (link.type == Kind.list) {
				var list_port:List_Port = cast node.get_port(link.id);
				var array = list_port.get_array();
				for (j in array) {
					perform(chain, node.hub.get_node(j), action, i + 1);
				}
				return;
			}
			else if (link.type == Kind.reference) {
				var id = node.get_value(link.id);
				node = node.hub.nodes[id];
			}
			else {
				throw new Exception("Not supported: " + link.name);
			}

		}

		action(node);
	}

}

