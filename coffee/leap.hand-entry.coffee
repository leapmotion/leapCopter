Leap.Controller.plugin 'handEntry', ->
  previousHandIds = []

  #http://stackoverflow.com/questions/3954438/remove-item-from-array-by-value
  `previousHandIds.remove = function() {
      var what, a = arguments, L = a.length, ax;
      while (L && this.length) {
          what = a[--L];
          while ((ax = this.indexOf(what)) !== -1) {
              this.splice(ax, 1);
          }
      }
      return this;
  };`

  onDeviceDisconnected = ->
    for id in previousHandIds
      @emit('handLost', this.lastConnectionFrame.hand(id))

  @on "deviceDisconnected", onDeviceDisconnected

  {
    frame: (frame)->
      newValidHandIds = frame.hands.map (hand)-> hand.id

      for id in previousHandIds
        if newValidHandIds.indexOf(id) == -1
          previousHandIds.remove id
          console.log 'hand lost', id
          @emit('handLost', frame.hand(id))

      for id in newValidHandIds
        if previousHandIds.indexOf(id) == -1
          previousHandIds.push id
          console.log 'hand found', id
          @emit('handFound', frame.hand(id))

    destroy: ->
      @removeListener 'deviceDisconnected', onDeviceDisconnected
  }

