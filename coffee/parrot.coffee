arDrone = require('ar-drone');

controller = new Leap.Controller()
controller.connect()
controller.use 'handHolding'
controller.use 'handActive'
controller.use 'handEntry'


class Parrot
  constructor: ->
    @state = 'grounded'
    @client = arDrone.createClient();
    @scaleFactor = 0.1

  takeOff: ->
    return unless @state == 'grounded'
    @state = 'flying'
    @client.takeoff()
    console.log 'takeOff'

  land: ->
    return unless @state == 'flying'
    console.log 'land'
    @state = 'grounded'
    @client.land()

  stop: ->
    @client.stop()

  setSpeed: (pitch, roll)->
    pitchPercent = Math.abs(pitch / (Math.PI/2)) * @scaleFactor
    console.log 'pitch', pitchPercent
    if pitch > 0
      @client.front pitchPercent

    else
      @client.back pitchPercent

#    rollPercent = Math.abs(roll / (Math.PI/2)) * @scaleFactor
#    if roll > 0
#      @client.left rollPercent
#    else
#      @client.right rollPercent




parrot = new Parrot()

controller.on 'handActive', ->
  console.log 'hand active'

controller.on 'handInactive', ->
  console.log 'hand inactive'

controller.on 'handActive', _.throttle ->
    parrot.takeOff()
  , 2000

controller.on 'handInactive', _.throttle ->
    parrot.land()
  , 2000

controller.on 'handLost', ->
  parrot.stop()

controller.on 'deviceDisconnected', ->
  console.log 'deviceDisconnected'
  parrot.land()
  parrot.client.disableEmergency()

controller.on 'frame', _.throttle (frame)->
    if hand = frame.hands[0]
      parrot.setSpeed(hand.pitch(), hand.roll())
  , 500