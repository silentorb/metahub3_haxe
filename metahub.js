//require('source-map-support').install()
var args = process.argv.slice(2)
console.log('args', args)
var MetaHub = require('./output/nodejs/metahub.js').metahub

var fs = require('fs')

var config_path = args[0]
function read_file(name) { return fs.readFileSync(name, { encoding: 'ascii' }) }
var path = require('path')
var root = path.dirname(config_path) + '/'
//console.log('root', root)
var config = JSON.parse(read_file(config_path))

var code = read_file(root + config.code)
var hub = new MetaHub.Hub()
hub.load_parser()

for (var i in config.schemas) {
  var schema_name = config.schemas[i]
  var schema = read_file(root + schema_name + '.json')
  var namespace = hub.schema.add_namespace(path.basename(schema_name, '.json'))
  hub.load_schema_from_string(schema, namespace)
}

var result = hub.parse_code(code)

if (!result.success)
  throw new Error("Syntax Error at " + result.end.y + ":" + result.end.x)
//var statement = run_data(result.get_data())
var statement = hub.run_data(result.get_data())
hub.generate(statement, 'cpp', path.resolve(root, config.output))
//var generator = new MetaHub.render.Generator(hub)
//generator.run(statement, 'cpp', path.resolve(root, config.output))
