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
  noflo.helpers.MapComponent c, (data, groups, out) ->
    unless window.requirejs
      c.outPorts.error.send new Error 'Require.js not available'
      c.outPorts.error.disconnect()
      return
    window.requirejs.config data
    out.send true
  ,
    inPort: 'config'
    outPort: 'ready'

  c
