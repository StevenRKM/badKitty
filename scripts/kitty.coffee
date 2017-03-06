'use strict'

define ['input', 'element', 'physics', 'random', 'sound'], (input, element, physics, random, sound) ->


    Node = element.Node
    Element = element.Element

    console.log "da kitty has started"

    sound.opening.play()


    # fix array, because it sux
    Array.prototype.remove = (element) ->

        index = @indexOf(element)
        if index != -1
            @splice index, 1


    # init shizzle
    canvas = document.createElement 'canvas'
    context = canvas.getContext '2d'
    CONTEXT = canvas.getContext '2d'

    width = () -> return window.innerWidth
    height = () -> return window.innerHeight

    time = () -> return (new Date()).getTime()
    now = time()


    canvas.width = width()
    canvas.height = height()
    document.body.appendChild canvas


    # resize on window resize
    resize = () ->
        canvas.width = width()
        canvas.height = height()
    window.addEventListener('resize', resize, false);


    # update loop
    update = () ->

        # loop through all update calls

        # update time, and interval
        _now = time()
        difference = _now - now

        if difference

            context.clearRect 0, 0, canvas.width, canvas.height

            SCENE._update  CONTEXT, difference/1000.0, _now

            now = _now

        window.requestAnimationFrame update


    class Avatar extends Element
        @width = 100
        @height = 100
        @speed = 500
        @reload = 500

        constructor: () ->
            super(100, 100, Avatar.width, Avatar.height)

            @ready = false
            @image = new Image()

            @image.onload = () ->
                console.log "IMAGE LOADED"

            @image.src = "http://placekitten.com/g/"+@width+"/"+@height


            @speed = Avatar.speed
            @reload = Avatar.reload

            @last_shot = 0

        update: (ctx, t) ->

            x = @x
            y = @y

            speed = @speed * t
#            console.log t, speed, @x, @y

            if input.state.UP then y -= speed
            if input.state.DOWN then y += speed
            if input.state.LEFT then x -= speed
            if input.state.RIGHT then x += speed
            if input.state.SHOOT and @last_shot + @reload < time() then @shoot()

            @x = x
            @y = y

            if not @ready
                @checkImage()

            if @ready
                ctx.drawImage @image, 0, 0


            # loading indicator
            reloading = time() - @last_shot

            if reloading <= 0
                reloading = 0
            else if reloading >= @reload
                reloading = 1
            else
                reloading /= @reload

            ctx.fillStyle = "#75331F"
            ctx.fillRect 0, @height-10, @width*(1-reloading), 10

        checkImage: () ->
            # During the onload event, IE correctly identifies any images that
            # weren’t downloaded as not complete. Others should too. Gecko-based
            # browsers act like NS4 in that they report this incorrectly.
            if not @image.complete
                return

            # However, they do have two very useful properties: naturalWidth and
            # naturalHeight. These give the true size of the image. If it failed
            # to load, either of these should be zero.

            if typeof @image.naturalWidth != "undefined" && @image.naturalWidth == 0
                return

            # No other way of checking: assume it’s ok.
            @ready = true

        shoot: () ->
            @last_shot = time()
            @parent.addNode new Bullet @x + @width, @y + @height/2

    class Bullet extends Element
        @width = 20
        @height = 5
        @speed = 1000

        constructor: (x, y) ->
            super(x, y, Bullet.width, Bullet.height)

            sound.laser.play()

            @ready = false
            @image = new Image()

            @image.onload = () ->
                console.log "IMAGE LOADED BULLET"

            @image.src = "http://placekitten.com/g/"+@width+"/"+@height

            @speed = Bullet.speed

        checkImage: () ->
            # During the onload event, IE correctly identifies any images that
            # weren’t downloaded as not complete. Others should too. Gecko-based
            # browsers act like NS4 in that they report this incorrectly.
            if not @image.complete
                return

            # However, they do have two very useful properties: naturalWidth and
            # naturalHeight. These give the true size of the image. If it failed
            # to load, either of these should be zero.

            if typeof @image.naturalWidth != "undefined" && @image.naturalWidth == 0
                return

            # No other way of checking: assume it’s ok.
            @ready = true

        update: (ctx, t) ->

            if not @ready
                @checkImage()

            @x += @speed * t

            if not @ready
                @checkImage()

            if @ready
                ctx.drawImage @image, 0, 0

    class Spawn extends Node

        constructor: () ->
            super()
            @next = time() + random.int(2000, 1000)

        update: () ->
            if @next < time()

                @parent.addNode new BadPussyCat width(), random.int(50, height()-50  )

                @next = time() + random.int(1000, 500)


    class BadPussyCat extends Element
        @width = 50
        @height = 50
        @speed = 300

        constructor: (x, y) ->
            super(x, y, BadPussyCat.width, BadPussyCat.height)

            @ready = false
            @image = new Image()

            @image.onload = () ->
                console.log "IMAGE LOADED BADPUSSYCAT"

            @image.src = "http://placekitten.com/g/"+@width+"/"+@height

            @speed = BadPussyCat.speed + random.int(300)
            console.warn @speed

        checkImage: () ->
            # During the onload event, IE correctly identifies any images that
            # weren’t downloaded as not complete. Others should too. Gecko-based
            # browsers act like NS4 in that they report this incorrectly.
            if not @image.complete
                return

            # However, they do have two very useful properties: naturalWidth and
            # naturalHeight. These give the true size of the image. If it failed
            # to load, either of these should be zero.

            if typeof @image.naturalWidth != "undefined" && @image.naturalWidth == 0
                return

            # No other way of checking: assume it’s ok.
            @ready = true

        update: (ctx, t) ->

            if not @ready
                @checkImage()

            @x -= @speed * t

            if not @ready
                @checkImage()

            if @ready
                ctx.drawImage @image, 0, 0



            for node in @parent.children
                if node instanceof Bullet and physics.collide node, @
                    UI.score++
#                    if chance 20
#                        @_scene.addElement new PowerUp @x, @y

                    sound.heavyHit.play()

                    @parent.addNode new Explosion @x+@width/2, @y+@height/2

                    @remove()
                    node.remove()
                    return

                if node instanceof Avatar and physics.collide node, @

                    sound.explosion.play()

                    @parent.addNode new Explosion @x+@width/2, @y+@height/2
                    @parent.addNode new BigExplosion node.x+node.width/2, node.y+node.height/2,input.state.UP, input.state.DOWN, input.state.LEFT, input.state.RIGHT

                    @remove()
                    node.remove()
                    return

            # remove if off screen
            if @x < -@width
                @remove()
                UI.escaped++

    class UI extends Node

        constructor: () ->
            super()
            @score = 0
            @escaped = 0

        update: (ctx, t) ->

            ctx.font = "48px serif";
            ctx.fillText "Bad Kitties killed: " + @score, 50, 50
            ctx.fillText "Bad Kitties escaped: " + @escaped, 50, 100


    class Explosion extends Element
        @speed = 300

        constructor: (x, y) ->
            super(x, y)

            removeAfter @

        removeAfter = (el) ->

            setTimeout () ->
                console.warn "REMOVE PARTICLES"
                el.remove()
            , 300

        update: (ctx, t) ->

            @x -= Explosion.speed * t
            @y += Explosion.speed * t / 4

            size = 25
            range = 30

            for i in [0...random.int(20, 10)]
                ctx.fillStyle = "hsl("+random.int(33)+", 100%, 50%)"
                sized = random.int(size, 5)

                point = random.inCircle range

                ctx.fillRect point.x, point.y, sized, sized


    class BigExplosion extends Element
        @speed = 500

        constructor: (x, y, @up, @down, @left, @right) ->
            super(x, y)

            removeAfter @

        removeAfter = (el) ->

            setTimeout () ->
                console.warn "REMOVE PARTICLES"
                el.remove()
            , 300

        update: (ctx, t) ->

            if @up and not @down
                @y -= BigExplosion.speed * t
            else if @down and not @up
                @y += BigExplosion.speed * t

            if @left and not @right
                @x -= BigExplosion.speed * t
            else if @right and not @left
                @x += BigExplosion.speed * t

            size = 50
            range = 100

            for i in [0...random.int(100, 20)]
                ctx.fillStyle = "hsl("+random.int(45)+", 100%, 50%)"
                sized = random.int(size, 5)

                # Pick two random numbers in the range (0, 1)
                # namely a and b. If b < a, swap them.
                # Your point is (b*R*cos(2*pi*a/b), b*R*sin(2*pi*a/b)).

                point = random.inCircle range

                ctx.fillRect point.x, point.y, sized, sized




    class UILayer extends Element

        constructor: (min, max, value) ->
            super()

            @nextHeight = 0

            @elements = {}

        addUIElemenet: (element) ->

            # auto height
            element.y = @nextHeight
            @nextHeight += element.height

            @elements[element.name] = element
            @addNode element

        getValue: (name) ->
            return @elements[name].value

        mouseDown: (event) ->
            for node in @children
                node.mouseDown event

        update: (ctx, t) ->

    class UIElement extends Element

        constructor: (@name, @value = 0) ->
            super()

        mouseDown: (event) -> return # overwrite me

    class UISlider extends UIElement

        constructor: (@name, @min, @max, @value) ->
            super(@name, @value)

            @height = 50
            @width = 350

        update: (ctx, t) ->

#            ctx.strokeRect 0, 0, @width, @height

            # background
            ctx.fillStyle = "hsl(200, 10%, 20%)"
            ctx.fillRect 0, 0, @width, @height

            # value bar

            relX = @value - @min
            valueWidth = if relX then relX/(@max-@min)*@width else 0

            ctx.fillStyle = "hsl(200, 100%, 30%)"
            ctx.fillRect 0, 0, valueWidth, @height

            # text
            ctx.fillStyle = "hsl(200, 100%, 80%)"
            ctx.font = "24px serif";
            ctx.fillText @min, 0, @height/2-5
            ctx.fillText @max, 0, @height-5
            ctx.fillText @name, @width-150, @height/2-5
            ctx.font = "60px serif";
            ctx.fillText Math.round(@value), 60, @height-5

        mouseDown: (event) ->
            if physics.pointInsideRect( {x: event.offsetX, y: event.offsetY}, @)
                relX = (event.offsetX - @x)/@width
                @value = ((@max-@min)*relX)+@min

    class FireSystem extends Element

        constructor: (x, y, @source) ->
            super(x, y)

            @max = 1000
            @particles = []
            @creationSpeed = 1

            for i in [0...@max]
                @particles.push {
                    alive: false
                    start: 0
                    end: 0
                    x: 0
                    y: 0
                    speed: 0
                    h: 0 # Hue is a degree on the color wheel (from 0 to 360) - 0 (or 360) is red, 120 is green, 240 is blue
                    s: 0 # Saturation is a percentage value; 0% means a shade of gray and 100% is the full color.
                    l: 0 # Lightness is also a percentage; 0% is black, 100% is white.
                    a: 0 # The alpha parameter is a number between 0.0 (fully transparent) and 1.0 (fully opaque).
                }

        update: (ctx, t, now) ->

            total = 0

            # settings
            particleSize = UI.getValue "particleSize"
            speedBase = UI.getValue "speedBase"
            speedRandom = UI.getValue "speedRandom"
            endBase = UI.getValue "endBase"
            endRandom = UI.getValue "endRandom"
            hue = UI.getValue "hue"
            hueSpread = UI.getValue "hueSpread"
            creationChance = UI.getValue "creationChance"
            spreadY = UI.getValue "spreadY"

            for p in @particles

                # update
                if p.alive
                    total++

                    # draw
                    ctx.fillStyle = "hsla("+p.h+", "+(p.s*100)+"%, "+(p.l*100)+"%, "+p.a+")"
                    ctx.fillRect p.x, p.y, particleSize, particleSize

                    # update movement
                    p.x -= p.speed * t

                    # die
                    if p.end < now
                        p.alive = false

                # create
                else
                    if random.chance creationChance

                        point = random.inCircle( (@source.height - particleSize)/2)

                        p.alive = true
                        p.start = now
                        p.end = now + endBase + random.rand()*endRandom
                        p.x = @source.x
                        p.y = @source.y + @source.height/2 + point.y
                        p.speed = speedBase + random.int speedRandom
                        p.h = (hue + random.int hueSpread) % 360
                        p.s = 1
                        p.l = 0.8
                        p.a = 0.5


            ctx.fillStyle = "hsla(0, 100%, 80%, 0.5)"
            ctx.font = "48px serif";
            ctx.fillText "Particles: " + total, 50, 50


    SCENE = new Node()
    AVATAR = new Avatar()
    UI = new UI()
    SCENE.addNode UI
    UI = new UILayer()
    SCENE.addNode UI
#    SCENE.addNode new FireSystem(800, 200)
    SCENE.addNode new FireSystem(0, 0, AVATAR)
    SCENE.addNode AVATAR
    SCENE.addNode new Spawn()
    #    SCENE.addNode new Explosion 800, 500


    UI.addUIElemenet new UISlider "particleSize", 1, 100, 15
    UI.addUIElemenet new UISlider "speedBase", 0, 100, 100
    UI.addUIElemenet new UISlider "speedRandom", 0, 200, 200
    UI.addUIElemenet new UISlider "endBase", 0, 5000, 1000
    UI.addUIElemenet new UISlider "endRandom", 0, 5000, 500
    UI.addUIElemenet new UISlider "hue", 0, 360, 0
    UI.addUIElemenet new UISlider "hueSpread", 0, 360, 46
    UI.addUIElemenet new UISlider "creationChance", 0, 100, 5
    UI.addUIElemenet new UISlider "spreadY", 0, 750, 30

    canvas.addEventListener 'mousedown', ( (event) -> UI.mouseDown(event) ), false

    update()

    width: width
    height: height
    canvas: canvas
    context: context
