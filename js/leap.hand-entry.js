// Generated by CoffeeScript 1.6.3
(function() {
  Leap.Controller.plugin('handEntry', function() {
    var onDeviceDisconnected, previousHandIds;
    previousHandIds = [];
    previousHandIds.remove = function() {
      var what, a = arguments, L = a.length, ax;
      while (L && this.length) {
          what = a[--L];
          while ((ax = this.indexOf(what)) !== -1) {
              this.splice(ax, 1);
          }
      }
      return this;
  };;
    onDeviceDisconnected = function() {
      var id, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = previousHandIds.length; _i < _len; _i++) {
        id = previousHandIds[_i];
        _results.push(this.emit('handLost', this.lastConnectionFrame.hand(id)));
      }
      return _results;
    };
    this.on("deviceDisconnected", onDeviceDisconnected);
    return {
      frame: function(frame) {
        var id, newValidHandIds, _i, _j, _len, _len1, _results;
        newValidHandIds = frame.hands.map(function(hand) {
          return hand.id;
        });
        for (_i = 0, _len = previousHandIds.length; _i < _len; _i++) {
          id = previousHandIds[_i];
          if (newValidHandIds.indexOf(id) === -1) {
            previousHandIds.remove(id);
            console.log('hand lost', id);
            this.emit('handLost', frame.hand(id));
          }
        }
        _results = [];
        for (_j = 0, _len1 = newValidHandIds.length; _j < _len1; _j++) {
          id = newValidHandIds[_j];
          if (previousHandIds.indexOf(id) === -1) {
            previousHandIds.push(id);
            console.log('hand found', id);
            _results.push(this.emit('handFound', frame.hand(id)));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      destroy: function() {
        return this.removeListener('deviceDisconnected', onDeviceDisconnected);
      }
    };
  });

}).call(this);
