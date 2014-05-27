noflo = require 'noflo'

# @runtime noflo-browser

class RequireModule extends noflo.AsyncComponent
  icon: 'dot-circle-o'
  description: 'Load an AMD module'

  constructor: ->
    @inPorts = new noflo.InPorts
      path:
        datatype: 'string'
        description: 'Path of the module to load'
    @outPorts = new noflo.OutPorts
      module:
        datatype: 'object'
      error:
        datatype: 'object'
        required: false

    super 'path', 'module'

  doRequire: (path, callback) ->
    window.requirejs [path], (module) =>
      @outPorts.module.beginGroup path
      @outPorts.module.send module
      @outPorts.module.endGroup path
      do callback
    , (err) ->
      callback err
  doAsync: (path, callback) ->
    return callback new Error 'Require.js not available' unless window.requirejs
    try
      @doRequire path, callback
    catch err
      try
        @doRequire path, callback
      catch e
        callback err

exports.getComponent = -> new RequireModule
