var buster = require("buster")
var assert = buster.referee.assert

buster.testCase("constrain", {
  "has the foo and bar": function () {
    assert.equals("foo", "bar")
  },

  "states the obvious": function () {
    assert(true)
  }
})