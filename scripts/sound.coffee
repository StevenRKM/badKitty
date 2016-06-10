'use strict'

define ["wad"], (Wad) ->

    explosion: new Wad({source : 'sounds/Explosion.wav', volume: 1})
    heavyHit: new Wad({source : 'sounds/HeavyHit.wav', volume: 0.5})
    heavyLaser: new Wad({source : 'sounds/HeavyLaser.wav'})
    laser: new Wad({source : 'sounds/Laser.wav', volume: 0.1})
    pling: new Wad({source : 'sounds/Pling.wav'})
    powerup: new Wad({source : 'sounds/Powerup.wav'})
