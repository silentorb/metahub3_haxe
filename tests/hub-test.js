require('source-map-support').install()
var buster = require("buster")
var assert = buster.referee.assert
var MetaHub = require('../output/nodejs/metahub.js')

function create_hub() {
  var hub = new MetaHub.Hub()
  hub.load_schema_from_file('tests/schema.json')
  return hub
}

buster.testRunner.handleUncaughtExceptions = false

buster.testCase("Hub", {
  "load schema": function () {
    var hub = create_hub()
    assert.equals(hub.schema.trellises.length, 2)
    assert.equals(hub.schema.trellises[0].name, 'Character')
  },

  "create node": function () {
    var hub = create_hub()
    hub.run({
      "type": "block",
      "expressions": [
        {
          "type": "create_symbol",
          "name": "boy",
          "expression": {
            "type": "create_node",
            "trellis": "Character",
            "set": {
              "name": {
                "type": "literal",
                "value": "James"
              }
            }
          }
        },
        {
          "type": "create_node",
          "trellis": "Item",
          "set": {
            "name": {
              "type": "literal",
              "value": "Vorpal Sword"
            },
            "owner": {
              "type": "reference",
              "path": "boy"
            }
          }
        }
      ]
    })
    console.log(hub.nodes);
    var node = hub.nodes[1]
    assert.equals(node.get_value_by_name('name'), 'James')
  }
})