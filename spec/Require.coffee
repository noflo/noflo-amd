noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  RequireModule = require '../components/Require.coffee'
else
  RequireModule = require 'noflo-amd/components/Require.js'

describe 'Require component', ->
  c = null
  path = null
  module = null
  beforeEach ->
    c = RequireModule.getComponent()
    path = noflo.internalSocket.createSocket()
    module = noflo.internalSocket.createSocket()
    c.inPorts.path.attach path
    c.outPorts.module.attach module

  describe 'when instantiated', ->
    it 'should have an path inport', ->
      chai.expect(c.inPorts.path).to.be.an 'object'
    it 'should have an module outport', ->
      chai.expect(c.outPorts.module).to.be.an 'object'

  describe 'loading a module that exists', ->
    it 'should return the module as expected', (done) ->
      module.on 'data', (module) ->
        chai.expect(module).to.be.a 'function'
        chai.expect(module('Foo')).to.equal 'Hello Foo'
        done()
      path.send 'fixtures/hello.js'

  describe 'loading a missing module', ->
    it 'should return the error as expected', (done) ->
      err = noflo.internalSocket.createSocket()
      c.outPorts.error.attach err

      err.on 'data', (error) ->
        chai.expect(error).to.be.an 'object'
        chai.expect(error.requireType).to.equal 'scripterror'
        chai.expect(error.requireModules).to.be.an 'array'
        chai.expect(error.requireModules[0]).to.equal 'fixtures/foo.js'
        done()
      path.send 'fixtures/foo.js'

  describe 'loading a module that requires another module', ->
    it 'should return the module as expected', (done) ->
      @timeout 20000
      module.on 'data', (module) ->
        chai.expect(module).to.be.a 'function'
        chai.expect(module('Foo')).to.equal 'Hello Foo'
        done()
      setTimeout ->
        path.send 'fixtures/world.js'
      , 1000
