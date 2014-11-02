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
var schema = read_file(root + config.schema)

var hub = new MetaHub.Hub()
hub.load_parser()
hub.load_schema_from_string(schema)
var result = hub.parse_code(code)

if (!result.success)
  throw new Exception("Syntax Error at " + result.end.y + ":" + result.end.x);

//var statement = run_data(result.get_data())
var statement = null
var generator = new MetaHub.generate.Generator(hub)
generator.run(statement, config.output)
