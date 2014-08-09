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

	public function resolve(node:Node):Dynamic {
		for (i in 0...(properties.length - 1)) {
			var property = properties[i];
			var node_id = node.get_value(property.id);
			if (node_id == null || node_id == 0)
				return null;

			node = node.hub.get_node(node_id);
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
					var parent_property = other_trellis.get_property("parent");
					if (parent_property != null)
						chain.push(parent_property);
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
}