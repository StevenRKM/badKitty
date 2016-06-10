'use strict'

define [], () ->
    
    int = (max=1, min=0) ->
        return Math.floor(min + Math.random()*(max+1 - min))

    chance = (percentage) ->
        return Math.random()*100 < percentage

    pick = (list) ->
        return list[ int list.length-1 ]

    inCircle = (radius) ->

        a = Math.random()
        b = Math.random()

        if b < a
            swap = b
            b = a
            a = swap

        ratio = if a == 0 then 0 else 2*Math.PI*a/b

        return {
            x: b * radius * Math.cos(ratio)
            y: b * radius * Math.sin(ratio)
        }


    int: int
    chance: chance
    pick: pick
    rand: Math.random
    inCircle: inCircle