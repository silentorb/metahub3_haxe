package metahub.code;
import metahub.engine.Node;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.schema.Kind;

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

	public function equals(other:Path):Bool {
		if (length != other.length)
			return false;

		for (i in 0...properties.length) {
			if (properties[i] != other.properties[i])
				return false;
		}

		return true;
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
			var property = trellis.get_property_or_error(token);
			path.push(property);
			if (i < source.length - 1)
				trellis = property.other_trellis;
		}
		return new Path(path);
	}

	public function resolve(node:Node):Dynamic {
		if (properties.length == 0)
			return node;

		for (i in 0...(properties.length - 1)) {
			var property = properties[i];
			var node = node.get_value(property.id);
			if (node == null)
				return null;
		}

		return node.get_value(last().id);
	}

	public function at(index:Int) {
		return properties[index];
	}

	public function reverse():Path {
		var chain = new Array<Property>();
		var i = properties.length - 1;
		while (i >= 0) {
			var property = properties[i];
			if (property.other_property != null)
				chain.push(property.other_property);
			else {
				var other_trellis = property.other_trellis;
				if (other_trellis != null && other_trellis.is_value) {
					chain.push(other_trellis.properties[other_trellis.properties.length - 1]);
				}
			}

			--i;
		}
		return new Path(chain);
	}

	public function slice(start:Int, end:Int = null) {
		if (end == null)
			return new Path(properties.slice(start));

		return new Path(properties.slice(start, end));
	}

	public function to_string():String {
		return Lambda.map(properties, function(i) { return i.name; }).join('.');
	}
}