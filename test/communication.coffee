microflo = require '../lib/microflo'
chai = require 'chai'

try
  build = require '../node_modules/microflo-emscripten/dist/microflo-runtime.js'
catch e
  console.log 'WARN: could not load Emscripten build', e.toString()

describeIfSimulator = if build? then describe else describe.skip

describeIfSimulator 'Device communication', ->
  runtime = new microflo.simulator.RuntimeSimulator build
  comm = new microflo.devicecommunication.DeviceCommunication runtime.transport

  before (done) ->
    runtime.start()
    comm.open () ->
        done()
  after (done) ->
    comm.close () ->
        runtime.stop()
        done()

  describe 'Sending ping', ->
      it 'should return pong', (done) ->
          comm.ping () ->
            done()

