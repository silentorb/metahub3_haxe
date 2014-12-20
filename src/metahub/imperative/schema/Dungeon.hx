package metahub.imperative.schema;
import metahub.imperative.types.*;
import metahub.logic.schema.Rail;
import metahub.logic.schema.Region;
import metahub.logic.schema.Tie;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Dungeon
{
	public var rail:Rail;
	public var code:Block;
	public var region:Region;
	public var trellis:Trellis;
	var inserts:Dynamic;
	var blocks = new Map<String, Array<metahub.imperative.types.Expression>>();
	var zones = new Array<Zone>();
	public var functions = new Array<Function_Definition>();

	public function new(rail:Rail) 
	{
		this.rail = rail;
		this.region = rail.region;
		trellis = rail.trellis;
		
		map_additional();
	}
	
	function map_additional() {
		if (!region.trellis_additional.exists(trellis.name))
			return;	
			
		var map:Rail_Additional = region.trellis_additional[trellis.name];

		if (Reflect.hasField(map, 'inserts'))
			inserts = map.inserts;
	}
	
	public function generate_code1() {
		var definition = new Class_Definition(this, []);
		var statements = [];
		var zone = create_zone(statements);
		zone.divide("..pre");
		var mid = zone.divide(null, [
			new Namespace(region, [ definition ])
		]);
		zone.divide("..post");

		code = {
			type: "block",
			statements: statements
		};

		blocks["/"] = definition.expressions;
	}

	public function generate_code2() {
		var statements = blocks["/"];
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

			var result = new Function_Definition('set_' + tie.tie_name, rail, [
				new Parameter("value", tie.get_signature())
			], []);

		var zone = create_zone(result.block);
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