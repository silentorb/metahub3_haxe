package metahub.code;
import metahub.engine.Context;
import metahub.engine.IPort;
import metahub.engine.Signal_Port;
import metahub.schema.Kind;
import metahub.schema.Property;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Context_Converter {
	var input_property:Property;
	public var input_port:Signal_Port;

	var output_property:Property;
	public var output_port:Signal_Port;

	public function new(input_property:Property, output_property:Property, kind:Kind) {
		this.input_property = input_property;
		this.output_property = output_property;

		input_port = new Signal_Port(kind, function(context) { return output_port.get_external_value(context); } );
		output_port = new Signal_Port(kind, function(context) { return input_port.get_external_value(context); } );


		input_port.on_change.push(function(input:Signal_Port, value:Dynamic, context:Context) {
			process(output_port, value, input_property, context);
		});

		output_port.on_change.push(function(input:Signal_Port, value:Dynamic, context:Context) {
			process(input_port, value, output_property, context);
		});
	}

	function create_context(context:Context, node_id:Int) {
		var node = context.hub.get_node(node_id);
		return new Context(node, context.hub);
	}

	function process(port:Signal_Port, value:Dynamic, property:Property, context:Context) {
		if (property.type == Kind.list) {
			var ids:Array<Int> = cast context.node.get_value(property.id);
			for (i in ids) {
				port.output(value, create_context(context, i));
			}
		}
		else {
			var node_id:Int = cast context.node.get_value(property.id);
			port.output(value, create_context(context, node_id));
		}
	}

}