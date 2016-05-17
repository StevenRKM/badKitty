'use strict'

define [], () ->

    STATE = {
        UP: false
        DOWN: false
        LEFT: false
        RIGHT: false
        SHOOT: false
    }
    
    key = (keycode, state) ->

        switch keycode
            when 87 then STATE.UP = state
            when 83 then STATE.DOWN = state
            when 65 then STATE.LEFT = state
            when 68 then STATE.RIGHT = state

            when 38 then STATE.UP = state
            when 40 then STATE.DOWN = state
            when 37 then STATE.LEFT = state
            when 39 then STATE.RIGHT = state

            when 32 then STATE.SHOOT = state

        chars = [
            if STATE.UP then 'U' else ' '
            if STATE.DOWN then 'D' else ' '
            if STATE.LEFT then 'L' else ' '
            if STATE.RIGHT then 'R' else ' '
            if STATE.SHOOT then 'S' else ' '
        ]
        console.log chars.join('')

    document.addEventListener 'keydown', (event) -> key event.keyCode, true
    document.addEventListener 'keyup', (event) -> key event.keyCode, false




    console.log "input bitches"

    state: STATE
