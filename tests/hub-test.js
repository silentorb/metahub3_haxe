require('source-map-support').install()
var buster = require("buster")
var assert = buster.referee.assert
var MetaHub = require('../output/nodejs/metahub.js')

function create_hub() {
  var hub = new MetaHub.Hub()
  hub.load_schema_from_file('tests/schema.json')
  return hub
}
create_hub();
buster.testRunner.handleUncaughtExceptions = false

buster.testCase("Hub", {
  "load schema": function () {
    var hub = create_hub()
    assert.greater(hub.schema.trellises.length, 2)
  },
  "node defaults": function () {
    var hub = create_hub()
    hub.run(
      {
        "type": "create_node",
        "trellis": "Character",
        "set": {
          "name": {
            "type": "literal",
            "value": "James"
          }
        }
      })
    var boy = hub.nodes[1]
    assert.equals(boy.get_value_by_name('name'), 'James')
    assert.same(boy.get_value_by_name('x'), 0)
  },
  "constraints": function () {
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
          "type": "create_symbol",
          "name": "sword",
          "expression": {
            "type": "create_node",
            "trellis": "Item",
            "set": {
              "name": {
                "type": "literal",
                "value": "Vorpal Sword"
              },
              "owner": {
                "type": "reference",
                "path": [ "boy" ]
              }
            }
          }
        },
        {
          "type": "create_constraint",
          "path": [ "boy", "x" ],
          "expression": {
            "type": "reference",
            "path": [ "sword", "y" ]
          }
        },
        {
          "type": "set",
          "path": [ "sword"],
          "assignments": [
            {
              "property": "y",
              "expression": {
                "type": "literal",
                "value": 5
              }
            }
          ]
        }
      ]
    })

    var boy = hub.nodes[1]

    var sword = hub.nodes[2]
    assert.equals(sword.get_value_by_name('owner'), 1)
    assert.equals(sword.get_value_by_name('y'), 5)
    assert.equals(boy.get_value_by_name('x'), 5)
  },

  "=>advanced constraints": function () {
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
          "type": "create_symbol",
          "name": "sword",
          "expression": {
            "type": "create_node",
            "trellis": "Item",
            "set": {
              "name": {
                "type": "literal",
                "value": "Vorpal Sword"
              },
              "owner": {
                "type": "reference",
                "path": [ "boy" ]
              }
            }
          }
        },
        {
          "type": "create_constraint",
          "path": [ "boy", "x" ],
          "expression": {
            "type": "function",
            "name": "sum",
            "inputs": [
              {
                "type": "reference",
                "path": [ "sword", "y" ]
              },
              {
                "type": "literal",
                "value": 1
              }
            ]
          }
        },
        {
          "type": "set",
          "path": [ "sword"],
          "assignments": [
            {
              "property": "y",
              "expression": {
                "type": "literal",
                "value": 5
              }
            }
          ]
        }
      ]
    })

    var boy = hub.nodes[1]
    var sword = hub.nodes[2]
    assert.equals(sword.get_value_by_name('y'), 5)
    assert.equals(boy.get_value_by_name('x'), 6)
  }
})