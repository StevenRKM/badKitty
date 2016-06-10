// Generated by CoffeeScript 1.10.0
'use strict';
define([], function() {
  var STATE, key;
  STATE = {
    UP: false,
    DOWN: false,
    LEFT: false,
    RIGHT: false,
    SHOOT: false
  };
  key = function(keycode, state) {
    var chars;
    switch (keycode) {
      case 87:
        STATE.UP = state;
        break;
      case 83:
        STATE.DOWN = state;
        break;
      case 65:
        STATE.LEFT = state;
        break;
      case 68:
        STATE.RIGHT = state;
        break;
      case 38:
        STATE.UP = state;
        break;
      case 40:
        STATE.DOWN = state;
        break;
      case 37:
        STATE.LEFT = state;
        break;
      case 39:
        STATE.RIGHT = state;
        break;
      case 32:
        STATE.SHOOT = state;
    }
    chars = [STATE.UP ? 'U' : ' ', STATE.DOWN ? 'D' : ' ', STATE.LEFT ? 'L' : ' ', STATE.RIGHT ? 'R' : ' ', STATE.SHOOT ? 'S' : ' '];
    return console.log(chars.join(''));
  };
  document.addEventListener('keydown', function(event) {
    return key(event.keyCode, true);
  });
  document.addEventListener('keyup', function(event) {
    return key(event.keyCode, false);
  });
  console.log("input bitches");
  return {
    state: STATE
  };
});

//# sourceMappingURL=input.js.map
