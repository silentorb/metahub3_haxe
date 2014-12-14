package metahub.imperative.schema ;
import metahub.imperative.code.List;
import metahub.imperative.types.Assignment;
import metahub.imperative.types.Block;
import metahub.imperative.code.Reference;
import metahub.imperative.types.Expression;
import metahub.imperative.types.Flow_Control;
import metahub.imperative.types.Function_Call;
import metahub.imperative.types.Function_Definition;
import metahub.imperative.types.Parameter;
import metahub.imperative.types.Parent_Class;
import metahub.imperative.types.Property_Expression;
import metahub.imperative.types.Statement;
import metahub.imperative.types.Variable;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.imperative.types.Expression_Type;

/**
 * ...
 * @author Christopher W. Johnson
 */

typedef Rail_Additional = {
	?name:String,
	?is_external:Bool,
	?source_file:String,
	?class_export:String
}

class Rail {

	public var trellis:Trellis;
	public var name:String;
	public var rail_name:String;
	public var dependencies = new Map<String, Dependency>();
	public var core_ties = new Map<String, Tie>();
	public var all_ties = new Map<String, Tie>();
	public var railway:Railway;
	public var parent:Rail;
	public var is_external = false;
	public var source_file:String = null;
	public var region:Region;
	public var hooks = new Map<String, Dynamic>();
	public var stubs = new Array<String>();
	public var property_additional = new Map<String, Property_Addition>();
	public var class_export:String = "";
	public var code:Block;
	var blocks = new Map<String, Array<metahub.imperative.types.Expression>>();
	var zones = new Array<Zone>();
	public var functions = new Array<Function_Definition>();

	public function new(trellis:Trellis, railway:Railway) {
		this.trellis = trellis;
		this.railway = railway;
		rail_name = this.name = trellis.name;
		region = railway.regions[trellis.namespace.name];
		is_external = region.is_external;
		class_export = region.class_export;
		load_additional();
		if (!is_external && source_file == null)
			source_file = trellis.namespace.name + '/' + rail_name;
	}

	function load_additional() {
		if (!region.trellis_additional.exists(trellis.name))
			return;

		var map:Rail_Additional = region.trellis_additional[trellis.name];

		if (Reflect.hasField(map, 'is_external'))
			is_external = map.is_external;

		if (Reflect.hasField(map, 'name'))
			rail_name = map.name;

		if (Reflect.hasField(map, 'source_file'))
			source_file = map.source_file;

		if (Reflect.hasField(map, 'class_export'))
			class_export = map.class_export;

		if (Reflect.hasField(map, 'hooks')) {
			var hook_source = Reflect.field(map, 'hooks');
			for (key in Reflect.fields(hook_source)) {
				hooks[key] = Reflect.field(hook_source, key);
			}
		}

		if (Reflect.hasField(map, 'stubs')) {
			var hook_source = Reflect.field(map, 'stubs');
			for (key in Reflect.fields(hook_source)) {
				stubs.push(Reflect.field(hook_source, key));
			}
		}

		if (Reflect.hasField(map, 'properties')) {
			var properties = Reflect.field(map, 'properties');
			for (key in Reflect.fields(properties)) {
				property_additional[key] = Reflect.field(properties, key);
			}
		}
	}

	public function process1() {
		if (trellis.parent != null) {
			parent = railway.get_rail(trellis.parent);
			add_dependency(parent).allow_ambient = false;
		}
		for (property in trellis.properties) {
			var tie = new Tie(this, property);
			all_ties[tie.name] = tie;
			if (property.trellis == trellis) {
				core_ties[tie.name] = tie;
				if (property.other_trellis != null) {
					var dependency = add_dependency(railway.get_rail(property.other_trellis));
					if (property.type == Kind.list)
						dependency.allow_ambient = false;
				}
			}
		}

		//generate_code();
	}
	
	public function process2() {
		for (tie in all_ties) {
			tie.initialize_links();
		}		
	}

	function add_dependency(rail:Rail):Dependency {
		if (!dependencies.exists(rail.name))
			dependencies[rail.name] = new Dependency(rail);

		return dependencies[rail.name];
	}
	
	public function flatten() {
		for (zone in zones) {
			zone.flatten();
		}
	}

	public function generate_code() {
		var class_definition = {
			"type": Expression_Type.class_definition,
			"rail": this,
			"statements": []
		}
		
		code = {
			type: "block",
			statements: [
				{
					type: Expression_Type.namespace,
					region: region,
					statements: [ class_definition ]
				}
			]
		};

		var statements = class_definition.statements;
		blocks["/"] = statements;
		
		statements.push(generate_initialize());

		for (tie in all_ties) {
			if (tie.type == Kind.list) {
				List.common_functions(tie);
			}
			else {
				var definition = generate_setter(tie);
				if (definition != null)
					statements.push(definition);
			}
		}
	}
	
	public function get_block(path:String) {
		if (!blocks.exists(path)) {
		}
		
		if (!blocks.exists(path))
			throw new Exception("Invalid rail block: " + path + ".");
		
		return blocks[path];
	}
	
	public function add_to_block(path:String, code:Expression) {
		var block = get_block(path);
		block.push(code);
	}
	
	public function concat_block(path:String, code:Array<Expression>) {
		var block = get_block(path);
		for (expression in code) {
			block.push(expression);
		}
	}
	
	public function create_zone(target = null) {
		var zone = new Zone(target, blocks);
		zones.push(zone);
		return zone;
	}

	function generate_setter(tie:Tie):Function_Definition {
		if (!tie.has_setter())
			return null;

			var result = new Function_Definition('set_' + tie.tie_name, this, [
				new Parameter("value", tie.get_signature())
			], []);
		
		var zone = create_zone(result.block);
		var pre = zone.divide(tie.tie_name + "_set_pre");
		
		var mid = zone.divide([
			new Flow_Control("if", { operator: "==", expressions: [
					new Property_Expression(tie), new Variable("value")
				]},
				[
					new Statement("return")
			]),
			new Assignment(new Property_Expression(tie), "=", new Variable("value"))
		]);
		
		var post = zone.divide(tie.tie_name + "_set_post");

		if (tie.has_set_post_hook) {
			post.push(new Function_Call(tie.get_setter_post_name(), [
					new Variable("value")
				]
			));
		}
			
		return result;

	}
	
	public function generate_initialize():Function_Definition {
		var block = [];
		blocks["initialize"] = block;
		if (parent != null) {
			block.push(new Parent_Class(
				new Function_Call("initialize")
			));
		}

		if (hooks.exists("initialize_post")) {
			block.push(new Function_Call("initialize_post"));
		}

		return new Function_Definition("initialize", this, [], block);		
	}
	
}