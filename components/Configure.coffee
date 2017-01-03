noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'dot-circle-o'
  c.description = 'Configure Require.js'
  c.inPorts.add 'config',
    datatype: 'object'
    description: 'Require.js configuration object'
  c.outPorts.add 'ready',
    datatype: 'bang'
    required: false
  c.outPorts.add 'error',
    datatype: 'object'
    required: false

  noflo.helpers.WirePattern c,
    in: 'config'
    out: 'ready'
    forwardGroups: true
    async: true
  , (data, groups, out, callback) ->
    unless window.requirejs
      return callback new Error 'Require.js not available'
      return
    window.requirejs.config data
    out.send true
    callback()
