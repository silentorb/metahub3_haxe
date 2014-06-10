require('source-map-support').install()
var buster = require("buster")
var assert = buster.referee.assert
var MetaHub = require('../output/nodejs/metahub.js')
var fs = require('fs')

var ansiColorizer = require("ansi-colorizer");
var color = ansiColorizer.configure({ color: true, bright: true });

function create_hub() {
  var hub = new MetaHub.Hub()
  hub.load_schema_from_file('test/schema.json')
  return hub
}

function pad(depth) {
  var result = ""
  for (var i = 0; i < depth; ++i)
    result += "  ";

  return result;
}

function render_info(info, depth, prefix) {
  depth = depth || 0
  prefix = prefix || ""
  var additional = info.debug_info()

  var tab = pad(depth)
  var text = info.pattern.type
    + (info.pattern.name != null ? " " + info.pattern.name : "")
    + " " + info.start.get_coordinate_string()

//  if (prefix)
//    text += " " + info.success

  text = info.success ? color.bold(text) : color.red(text)

  text = tab + prefix + text

  if (additional)
    text += " " + additional.replace(/\r?\n/g, color.purple('\\n'))

  text += render_info_children(info, depth + 1)

  if (info.messages)
    text += "\n" + color.cyan(info.messages.map(function (m) {
      return tab + "  " + m
    }).join("\n"))
  return text
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

buster.testCase("Parser", {
  "simple test": function () {
    var definition = new MetaHub.parser.Definition()
    definition.load_parser_schema()
    var parser = new MetaHub.parser.Bootstrap(definition)
    parser.debug = true
//    parser.draw_offsets = true
    var code = fs.readFileSync('metahub/metahub.grammar', { encoding: 'ascii' });
//    var code = fs.readFileSync('test/string.grammar', { encoding: 'ascii' });
    var result = parser.parse(code)
//    console.log(render_info(result))
//    console.log('"result":', JSON.stringify(data, null, "  "))

//    assert.equals(keys[0], 'start')

    var match = result
    var offset = match.start.move(match.length)
//    console.log(offset, code.length);
    if (offset.get_offset() < code.length) {
      throw new Error("Could not find match at " + offset.get_coordinate_string()
        + " [" + code.substr(offset.get_offset()) + "]");
    }

    if (!result.success)
      throw new Error('match failed');

    var data = result.get_data()
    console.log(data)
    assert(data)
    var keys = Object.keys(data)
    assert.greater(keys.length, 1)
  },
  "parse shorthand": function () {
    var hub = create_hub();
    hub.load_parser();
    var code = fs.readFileSync('test/boy.mh', { encoding: 'ascii' })

    var result = hub.parse_code(code);
    console.log(render_info(result))
    assert(result.success, 'Match found.')
    var data = result.get_data()
    console.log(require('util').inspect(data, { showHidden: false, depth: 10 }));
    assert(data);
  },
  "run shorthand": function () {
    var hub = create_hub();
    hub.load_parser();
    var code = fs.readFileSync('test/boy.mh', { encoding: 'ascii' })
    hub.run_code(code);

    var boy = hub.nodes[1]
    var sword = hub.nodes[2]
    assert.equals(sword.get_value_by_name('y'), 5)
    assert.equals(boy.get_value_by_name('x'), 6)
  },
  "parse shorthand trellis constraint": function () {
    var hub = create_hub();
    hub.load_parser();
    var code = fs.readFileSync('test/general.mh', { encoding: 'ascii' })

    var result = hub.parse_code(code);
    console.log(render_info(result))
    assert(result.success, 'Match found.')
    var data = result.get_data()
    console.log(require('util').inspect(data, { showHidden: false, depth: 10 }));
    assert(data);
  },
  "=>run shorthand trellis constraint": function () {
    var hub = create_hub();
    hub.load_parser();
    var code = fs.readFileSync('test/general.mh', { encoding: 'ascii' })
    hub.run_code(code);

    var boy = hub.nodes[1]
    var sword = hub.nodes[2]
    assert.equals(boy.get_value_by_name('x'), 6)
    assert.equals(sword.get_value_by_name('y'), 5)
  }
})