noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'dot-circle-o'
  c.description = 'Load an AMD module'

  c.inPorts.add 'path',
    datatype: 'string'
    description: 'Path of the module to load'
  c.outPorts.add 'module',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
    required: false

  noflo.helpers.WirePattern c,
    in: 'path'
    out: 'module'
    forwardGroups: true
    async: true
  , (path, groups, out, callback) ->
    return callback new Error 'Require.js not available' unless window.requirejs
    window.requirejs [path], (module) ->
      out.beginGroup path
      out.send module
      out.endGroup path
      do callback
    , (err) ->
      callback err
