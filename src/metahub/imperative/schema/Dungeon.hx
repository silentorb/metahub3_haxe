package metahub.imperative.schema;
import metahub.imperative.Imp;
import metahub.imperative.types.*;
import metahub.logic.schema.Rail;
import metahub.logic.schema.Region;
import metahub.logic.schema.Tie;
import metahub.schema.Trellis;
import metahub.schema.Kind;
import metahub.imperative.code.List;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Dungeon
{
	public var rail:Rail;
	public var code:Array<Expression>;
	public var region:Region;
	public var trellis:Trellis;
	var inserts:Dynamic;
	var blocks = new Map<String, Array<metahub.imperative.types.Expression>>();
	var zones = new Array<Zone>();
	public var functions = new Array<Function_Definition>();
	public var imp:Imp;
	public var lairs = new Map<String, Lair>();
	public var used_functions = new Map<String, Used_Function>();

	public function new(rail:Rail, imp:Imp) 
	{
		this.rail = rail;
		this.imp = imp;
		this.region = rail.region;
		trellis = rail.trellis;
		
		map_additional();
		
		for (tie in rail.all_ties) {
			var lair = new Lair(tie, this);
			lairs[tie.name] = lair;
		}
	}
	
	function map_additional() {
		if (!region.trellis_additional.exists(trellis.name))
			return;	
			
		var map:Rail_Additional = region.trellis_additional[trellis.name];

		if (Reflect.hasField(map, 'inserts'))
			inserts = map.inserts;
	}
	
	public function generate_code1() {
		var definition = new Class_Definition(rail, []);
		code = [];
		var zone = create_zone(code);
		zone.divide("..pre");
		var mid = zone.divide(null, [
			new Namespace(region, [ definition ])
		]);
		zone.divide("..post");

		blocks["/"] = definition.expressions;
	}

	public function generate_code2() {
		var statements = blocks["/"];
		statements.push(generate_initialize());

		for (tie in rail.all_ties) {
			if (tie.type == Kind.list) {
				List.common_functions(tie, imp);
			}
			else {
				var definition = generate_setter(tie);
				if (definition != null)
					statements.push(definition);
			}
		}

		if (inserts != null) {
			for (path in Reflect.fields(inserts)) {
				var lines:Array<String> = Reflect.field(inserts, path);
				concat_block(path, cast lines.map(function(s) return new Insert(s)));
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

	public function flatten() {
		for (zone in zones) {
			zone.flatten();
		}
	}
	
	function generate_setter(tie:Tie):Function_Definition {
		if (!tie.has_setter())
			return null;

			var result = new Function_Definition('set_' + tie.tie_name, this, [
				new Parameter("value", tie.get_signature())
			], []);

		var zone = create_zone(result.expressions);
		var pre = zone.divide(tie.tie_name + "_set_pre");

		var mid = zone.divide(null, [
			new Flow_Control("if", new Condition("==", [
					new Property_Expression(tie), new Variable("value")
				]),
				[
					new Statement("return")
			]),
			new Assignment(new Property_Expression(tie), "=", new Variable("value"))
		]);
		if (tie.type == Kind.reference && tie.other_tie != null) {
			if (tie.other_tie.type == Kind.reference) {
				mid.push(new Property_Expression(tie,
					new Function_Call("set_" + tie.other_tie.tie_name, [new Self()]))
				);
			}
			else {
				mid.push(new Property_Expression(tie,
					new Function_Call(tie.other_tie.tie_name + "_add", [new Self(), new Self()]))
				);
			}
		}

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
		if (rail.parent != null) {
			block.push(new Parent_Class(
				new Function_Call("initialize")
			));
		}
		
		for (lair in lairs) {
			lair.customize_initialize(block);
		}

		if (rail.hooks.exists("initialize_post")) {
			block.push(new Function_Call("initialize_post"));
		}

		return new Function_Definition("initialize", this, [], block);
	}
	
	public function post_analyze(expression:Expression) {
		switch(expression.type) {
			
			case Expression_Type.namespace:
				var ns:Namespace = cast expression;
				post_analyze_many(ns.expressions);

			case Expression_Type.class_definition:
				var definition:Class_Definition = cast expression;
				post_analyze_many(definition.expressions);

			case Expression_Type.function_definition:
				var definition:Function_Definition = cast expression;
				post_analyze_many(definition.expressions);

			case Expression_Type.flow_control:
				var definition:Flow_Control = cast expression;
				post_analyze_many(definition.condition.expressions);
				post_analyze_many(definition.children);

			case Expression_Type.function_call:
				var definition:Function_Call = cast expression;
				trace('func', definition.name);
				if (definition.is_platform_specific && !used_functions.exists(definition.name))
					used_functions[definition.name] = new Used_Function(definition.name, definition.is_platform_specific);
				
				for (arg in definition.args) {
					if (Reflect.hasField(arg, 'type'))
						post_analyze(arg);
				}

			case Expression_Type.assignment:
				var definition:Assignment = cast expression;
				post_analyze(definition.expression);

			case Expression_Type.declare_variable:
				var definition:Declare_Variable = cast expression;
				post_analyze(definition.expression);
				
			//case Expression_Type.property:
				//var property_expression:Property_Expression = cast expression;
				//result = property_expression.tie.tie_name;

			//case Expression_Type.instantiate:

			default:
				// Do nothing.  This is a gentler function than most MetaHub expression processors.
		}
	}
	
	public function post_analyze_many(expressions:Array<Expression>) {
		for (expression in expressions) {
			post_analyze(expression);
		}
	}
}