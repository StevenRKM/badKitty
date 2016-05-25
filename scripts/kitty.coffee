'use strict'

define ['input', 'element', 'physics', 'random'], (input, element, physics, random) ->

    Node = element.Node
    Element = element.Element


    console.log "da kitty has started"



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


    # upodate loop
    update = () ->

        # loop through all update calls

        # update time, and interval
        _now = time()
        difference = _now - now

        if difference

            context.clearRect 0, 0, canvas.width, canvas.height

            SCENE._update  CONTEXT, difference/1000.0

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

                @next = time() + random.int(2000, 1000)


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

            @speed = BadPussyCat.speed

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
#                    if chance 20
#                        @_scene.addElement new PowerUp @x, @y

                    @remove()
                    node.remove()
                    return

                if node instanceof Avatar and physics.collide node, @
                    @remove()
                    node.remove()
                    return

            # remove if off screen
            if @x < -@width
                @remove()


    SCENE = new Node()
    AVATAR = new Avatar()
    SCENE.addNode AVATAR
    SCENE.addNode new Spawn()

    update()

    width: width
    height: height
    canvas: canvas
    context: context