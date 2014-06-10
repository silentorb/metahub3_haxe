package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import parser.Match;

class ParserTest
{
	private var timer:Timer;

	public function new()
	{

	}

	@BeforeClass
	public function beforeClass():Void
	{
	}

	@AfterClass
	public function afterClass():Void
	{
	}

	@Before
	public function setup():Void
	{
	}

	@After
	public function tearDown():Void
	{
	}

	function pad(depth) {
		var result = "";
		for (i in 0...depth)
			result += "  ";

		return result;
	}

	function render_info(info, depth, prefix) {
		depth = depth || 0;
		prefix = prefix || "";
		var additional = info.debug_info();

		var tab = pad(depth);
		var text = tab + prefix + info.pattern.type
			+ (info.pattern.name != null ? " " + info.pattern.name : "")
			+ " " + info.start.get_coordinate_string();

		text = info.success ? color.bold(text) : color.red(text);

		if (additional)
			text += " " + additional.replace(/\r?\n/g, color.purple('\\n'));

		text += render_info_children(info, depth + 1);

		if (info.messages)
			text += "\n" + color.cyan(info.messages.map(function (m) {
				return tab + "  " + m
			}).join("\n"));

		return text;
	}

	function render_info_children(info, depth) {
		if (info.children.length == 0)
			return "";

		return "\n" + info.children.map(function (child) {
			var prefix = child.pattern == info.pattern.divider
				? color.purple("<")
				: ""
			return render_info(child, depth, prefix)
		})
			.join("\n");
	}


	@Test
	public function testExample():Void
	{
		var definition = new parser.Definition();
    definition.load_parser_schema();
		var parser = new parser.Bootstrap(definition);
    parser.debug = true;
//    parser.draw_offsets = true
		var code = metahub.Macros.insert_file_as_string("test/parser.txt");

    //var code = File.getContent('test/parser.txt');
    var result = parser.parse(code);
		Assert.isTrue(result.success);
		if (!result.success)
			return;

		var match:Match = cast result;
		var data = match.get_data();
		trace(data);
		//trace(render_info(result));
    Assert.isTrue(data);
    var keys = Reflect.fields(data);
    Assert.isTrue(keys.length > 1);
	}

	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}