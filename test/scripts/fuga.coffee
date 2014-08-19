{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @sender = new User 'bouzuya', room: 'hitoridokusho'
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot fuga"', ->
      beforeEach ->
        message = '@hubot fuga'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @callback.callCount is 1
        match = @callback.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is '@hubot fuga'

  describe 'listeners[0].callback', ->
    beforeEach ->
      @fuga = @robot.listeners[0].callback

    describe 'receive "@hubot fuga" (random = 0.12)', ->
      beforeEach ->
        @sinon.stub Math, 'random', ->
          0.12
        @send = @sinon.spy()
        @fuga
          match: ['@hubot fuga']
          send: @send

      it 'send "fuga"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'fuga'

    describe 'receive "@hubot fuga" (random = 0.11)', ->
      beforeEach ->
        @sinon.stub Math, 'random', ->
          0.11
        @send = @sinon.spy()
        @fuga
          match: ['@hubot fuga']
          send: @send

      it 'send "poyo"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'poyo'

    describe 'receive "@hubot fuga" (random = 0.01)', ->
      beforeEach ->
        @sinon.stub Math, 'random', ->
          0.01
        @send = @sinon.spy()
        @fuga
          match: ['@hubot fuga']
          send: @send

      it 'send "fugapoyo"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'fugapoyo'
