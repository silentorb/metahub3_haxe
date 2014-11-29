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
if (typeof config.namespace != 'string')
	throw new Error('Configuration is missing "namespace".');

var code = read_file(root + config.code)
var schema = read_file(root + config.schema)

var hub = new MetaHub.Hub()
hub.load_parser()
hub.load_schema_from_string(schema, hub.schema.add_namespace(config.namespace))
var result = hub.parse_code(code)

if (!result.success)
  throw new Error("Syntax Error at " + result.end.y + ":" + result.end.x)
//var statement = run_data(result.get_data())
var statement = hub.run_data(result.get_data())
var generator = new MetaHub.generate.Generator(hub)
generator.run(statement, 'cpp', root + config.output)
