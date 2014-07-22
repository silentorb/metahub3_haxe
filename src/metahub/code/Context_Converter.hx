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

		input_port = new Signal_Port(kind);
		output_port = new Signal_Port(kind);

		input_port.on_change.push(function(input:Signal_Port, value:Dynamic, context:Context) {
			output_port.output(value, create_context(context, input_property));
		});

		output_port.on_change.push(function(input:Signal_Port, value:Dynamic, context:Context) {
			input_port.output(value, create_context(context, output_property));
		});
	}

	function create_context(context:Context, property:Property) {
		var node_id:Int = cast context.node.get_value(property.id);
		var node = context.hub.get_node(node_id);
		return new Context(node, context.hub);
	}

}