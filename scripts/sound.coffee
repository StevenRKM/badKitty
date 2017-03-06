'use strict'

define ["wad"], (Wad) ->

    class Sound
        constructor: (options) ->
            @sound = new Wad(options)

        play: () ->
#            @sound.play()

    opening: new Sound({source : 'sounds/Opening.wav', volume: 1})
    explosion: new Sound({source : 'sounds/Explosion.wav', volume: 1})
    heavyHit: new Sound({source : 'sounds/HeavyHit.wav', volume: 0.5})
    heavyLaser: new Sound({source : 'sounds/HeavyLaser.wav'})
    laser: new Sound({source : 'sounds/Laser.wav', volume: 0.1})
    pling: new Sound({source : 'sounds/Pling.wav'})
    powerup: new Sound({source : 'sounds/Powerup.wav'})
