# returns a clutch parameter, which shows % figner extension.
# fires off a finger extended event on 100%.
# returns activity state of each finger
# if any figer is active, the hand is active

Leap.Controller.plugin 'handActive', (options)->
  {
    hand: (hand)->
      if hand.timeVisible > 0
        # todo: in skeletal, we get back finger type of thumb, and can set fingerActiveCount back to 2
#        console.log 'finger count', hand.fingers.length
        if hand.fingers.length > 2
          if hand.data('hasBeenSeenInactive')
            unless hand.data('active')
              hand.data('active', true)
              @emit 'handActive', hand
        else
          hand.data('hasBeenSeenInactive', true)
          if hand.data('active')
            # todo: hand.data(key, val) = buggy
            hand.data({active: false})
            @emit 'handInactive', hand
      else
        console.log 'Hand slipped (low frame confidence)'


  }