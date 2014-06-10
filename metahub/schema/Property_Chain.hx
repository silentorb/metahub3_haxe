package schema;

/**
 * @author Christopher W. Johnson
 */

typedef Property_Chain = Array<Property>;

class Property_Chain_Helper {
	public static function flip(chain:Property_Chain):Property_Chain {
		var result = new Property_Chain();
		for (i in chain.length...0) {
				result.push(chain[i].other_property);
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

}

