// Generated by CoffeeScript 1.6.3
(function() {
  Leap.Controller.plugin('handActive', function(options) {
    return {
      hand: function(hand) {
        if (hand.timeVisible > 0) {
          if (hand.fingers.length > 2) {
            if (hand.data('hasBeenSeenInactive')) {
              if (!hand.data('active')) {
                hand.data('active', true);
                this.emit('handActive', hand);
                return console.log('active');
              }
            }
          } else {
            hand.data('hasBeenSeenInactive', true);
            if (hand.data('active')) {
              hand.data({
                active: false
              });
              return this.emit('handInactive', hand);
            }
          }
        } else {
          return console.log('Hand slipped (low frame confidence)');
        }
      }
    };
  });

}).call(this);
