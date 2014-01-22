arDrone = require('ar-drone');

controller = new Leap.Controller()
controller.connect()
controller.use 'handHolding'
controller.use 'handActive'
controller.use 'handEntry'

testMode = true
document.getElementById('test-mode').innerHTML = testMode

window.visualizer = document.getElementById('copter');

visualizer.top = (n)->
  n ||= 0
  @style.top = (window.innerHeight / 2) + n + 'px'

visualizer.left = (n)->
  n ||= 0
  @style.left = (window.innerWidth / 2) + n + 'px'

visualizer.top()
visualizer.left()

class Parrot
  constructor: ->
    @state = 'grounded'
    @client = arDrone.createClient();
    @scaleFactor = 0.5

  takeOff: ->
    return unless @state == 'grounded'
    @state = 'flying'
    @client.takeoff() unless testMode
    console.log 'takeOff'
    visualizer.className = 'active'

  land: ->
    return unless @state == 'flying'
    console.log 'land'
    @state = 'grounded'
    @client.land() unless testMode
    visualizer.className = ''

  stop: ->
    @client.stop() unless testMode

  setSpeed: (pitch, roll)->
    pitchPercent = Math.abs(pitch / (Math.PI/2)) * @scaleFactor
    if pitch < 0
      @client.front(pitchPercent) unless testMode
      visualizer.top(pitchPercent * -100)
    else
      @client.back(pitchPercent) unless testMode
      visualizer.top(pitchPercent * 100)


    rollPercent = Math.abs(roll / (Math.PI/2)) * @scaleFactor
    if roll > 0
      @client.left rollPercent unless testMode
      visualizer.left(rollPercent * -100)
    else
      @client.right rollPercent unless testMode
      visualizer.left(rollPercent * 100)






parrot = new Parrot()
document.getElementById('scale-factor').innerHTML = parrot.scaleFactor

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
  parrot.land()
  parrot.client.disableEmergency()

controller.on 'frame', (frame)->
  if hand = frame.hands[0]
    parrot.setSpeed(hand.pitch() - 0.2, hand.roll())