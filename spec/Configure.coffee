noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-amd'

describe 'Configure component', ->
  c = null
  config = null
  ready = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'amd/Configure', (err, instance) ->
      return done err if err
      c = instance
      config = noflo.internalSocket.createSocket()
      c.inPorts.config.attach config
      done()
  beforeEach ->
    ready = noflo.internalSocket.createSocket()
    c.outPorts.ready.attach ready
  afterEach ->
    c.outPorts.ready.detach ready

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
