package metahub.code.expressions;
import metahub.code.nodes.Context_Converter;
import metahub.code.nodes.Property_Node;
import metahub.code.references.*;
import metahub.engine.General_Port;
import metahub.code.nodes.Group;
import metahub.schema.Property;
import metahub.schema.Trellis;
import metahub.engine.Node;
import metahub.code.nodes.Path_Condition;

class Property_Reference implements Token_Expression {
	public var property:Property;
	public var children = new Array<Expression>();

  public function new(property:Property) {
    this.property = property;
  }

  public function to_port(scope:Scope, group:Group, signature_node:Type_Signature):General_Port {
		throw new Exception("Not supported.");
  }

	public function to_token_port(scope:Scope, group:Group, signature:Array < Type_Signature > , is_last:Bool):General_Port {
		var node = new Property_Node(property, group, !is_last);
		var other_port = is_last
			? property.trellis.get_port(property.id)
			: property.trellis.readonly_ports[property.id];

		node.get_port(1).connect(other_port);
		return node.get_port(0);
  }

	public function get_type(out_type:Type_Signature = null):Array < Type_Signature > {
		return [ property.get_signature() ];
	}

	public function to_string():String {
		return property.fullname();
	}
}