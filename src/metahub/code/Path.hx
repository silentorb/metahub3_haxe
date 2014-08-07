package metahub.code;
import metahub.schema.Property;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Path {

	var properties:Array<Property>;
	public var length:Int;

	public function new(properties:Array<Property>) {
		this.properties = properties;
		length = properties.length;
	}

	public function first() {
		return properties[0];
	}

	public function last() {
		return properties[properties.length - 1];
	}

	public static function from_array(source:Array<String>, trellis:Trellis):Path {
		var path = new Array<Property>();
		for (i in 0...source.length) {
			var token = source[i];
			var property = trellis.get_property(token);
			path.push(property);
			if (i < source.length - 1)
				trellis = property.other_trellis;
		}
		return new Path(path);
	}

}