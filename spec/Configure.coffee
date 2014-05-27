noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Configure = require '../components/Configure.coffee'
else
  Configure = require 'noflo-amd/components/Configure.js'

describe 'Configure component', ->
  c = null
  config = null
  ready = null
  beforeEach ->
    c = Configure.getComponent()
    config = noflo.internalSocket.createSocket()
    ready = noflo.internalSocket.createSocket()
    c.inPorts.config.attach config
    c.outPorts.ready.attach ready

  describe 'when instantiated', ->
    it 'should have an config inport', ->
      chai.expect(c.inPorts.config).to.be.an 'object'
    it 'should have an ready outport', ->
      chai.expect(c.outPorts.ready).to.be.an 'object'

  describe 'when configuring', ->
    it 'should emit ready when done', (done) ->
      ready.on 'data', (data) ->
        chai.expect(data).to.be.a 'boolean'
        done()
      config.send
        config:
          'fixtures/hello.js':
            greeting: 'Hello'
