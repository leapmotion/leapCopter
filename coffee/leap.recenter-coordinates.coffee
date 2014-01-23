Leap.Controller.plugin 'recenterCoordinates', ->
  center = [0,0,0]
  {
    hand: (hand)->
      Leap.vec3.sub(hand.stabilizedPalmPosition, hand.stabilizedPalmPosition, center)
      Leap.vec3.sub(hand.palmPosition, hand.palmPosition, center)
    frame: {
      recenterCoordinates: (newCenter)->
        console.log('recentering')
        center = newCenter
    }
  }