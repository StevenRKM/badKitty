'use strict'

define [], () ->
    
    int = (max=1, min=0) ->
        return Math.floor(min + Math.random()*(max+1 - min))

    chance = (percentage) ->
        return Math.random()*100 < percentage

    pick = (list) ->
        return list[ int list.length-1 ]



    int: int
    chance: chance
    pick: pick