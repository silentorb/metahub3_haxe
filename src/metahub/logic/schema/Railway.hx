package metahub.logic.schema ;
import metahub.Hub;
import metahub.meta.types.Constraint;
import metahub.meta.types.Expression;
import metahub.meta.types.Expression_Type;
import metahub.meta.Scope;

import metahub.parser.Result;
import metahub.schema.Kind;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Railway {

	public var root_region:Region;
	public var regions = new Map<String, Region>();
	public var target_name:String;

	public function new(hub:Hub, target_name:String) {
		this.target_name = target_name;
		
		root_region = new Region(hub.schema.root_namespace, "/");
		initialize_root_functions();

		for (namespace in hub.schema.root_namespace.children) {
			if (namespace.name == 'metahub')
				continue;

			var region = new Region(namespace, target_name);
			regions[namespace.name] = region;
			root_region.children[region.name] = region;

			for (trellis in namespace.trellises) {
				region.rails[trellis.name] = new Rail(trellis, this);
			}
		}

		for (region in regions) {
			for (rail in region.rails) {
				rail.process1();
			}
		}
		
		for (region in regions) {
			for (rail in region.rails) {
				rail.process2();
			}
		}
	}

	public static function get_class_name(expression):String {
		return Type.getClassName(Type.getClass(expression)).split('.').pop();
	}

	public function get_rail(trellis:Trellis):Rail {
		return regions[trellis.namespace.name].rails[trellis.name];
	}
	
	
	//public function translate(expression:metahub.meta.types.Expression):metahub.imperative.types.Expression {
		//switch(expression.type) {
			//case metahub.meta.types.Expression_Type.literal:
				//var literal:metahub.meta.types.Literal = cast expression;
				//return new metahub.imperative.types.Literal(literal.value);
//
			//case metahub.meta.types.Expression_Type.function_call:
				//var func:metahub.meta.types.Function_Call = cast expression;
				//return new metahub.imperative.types.Function_Call(func.name, [translate(func.input)]);
//
			//case metahub.meta.types.Expression_Type.path:
				//return convert_path(cast expression);
//
			//case metahub.meta.types.Expression_Type.block:
				//var array:metahub.meta.types.Block = cast expression;
				//return new metahub.imperative.types.Create_Array(array.children.map(function(e) return translate(e)));
//
			//default:
				//throw new Exception("Cannot convert expression " + expression.type + ".");
		//}
	//}
//
	//public function convert_path(expression:metahub.meta.types.Path):metahub.imperative.types.Expression {
		//var path = expression.children;
		//var result = new Array<metahub.imperative.types.Expression>();
		//var first:metahub.meta.types.Property_Expression = cast path[0];
		//var rail:Rail = cast first.property.get_abstract_rail();
		//for (token in path) {
			//if (token.type == metahub.meta.types.Expression_Type.property) {
				//var property_token:metahub.meta.types.Property_Expression = cast token;
				//var tie = rail.all_ties[cast property_token.property.name];
				//if (tie == null)
					//throw new Exception("tie is null: " + property_token.property.fullname());
//
				//result.push(new metahub.imperative.types.Property_Expression(tie));
				//rail = tie.other_rail;
			//}
			//else {
				//var function_token:metahub.meta.types.Function_Call = cast token;
				//result.push(new metahub.imperative.types.Function_Call(function_token.name, [], true));
			//}
		//}
		//return new metahub.imperative.types.Path(result);
	//}
	
	public function resolve_rail_path(path:Array<String>):Rail {
		var tokens = path.copy();
		var rail_name = tokens.pop();
		var region = root_region;
		for (token in tokens) {
			if (!region.children.exists(token))
				throw new Exception("Region " + region.name + " does not have namespace: " + token + ".");
				
			region = region.children[token];
		}
		
		if (!region.rails.exists(rail_name))
			throw new Exception("Region " + region.name + " does not have a rail named " + rail_name + ".");
			
		return region.rails[rail_name];
	}
	
	function initialize_root_functions() {
		root_region.add_functions([
		
			new Function_Info("count", [
				new Function_Version({ type: Kind.list, rail:null }, { type:Kind.int })
			]),
			
			new Function_Info("cross", [
				new Function_Version({ type: Kind.list, rail:null }, { type:Kind.none })
			]),
			
			new Function_Info("dist", [
				new Function_Version({ type: Kind.list, rail:null }, { type:Kind.none })
			]),
		]);
	}
}