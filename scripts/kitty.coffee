'use strict'

define ['input'], (input) ->

    console.log "da kitty has started"



    # fix array, because it sux
    Array.prototype.remove = (element) ->

        index = @indexOf(element)
        if index != -1
            @splice index, 1


    # init shizzle
    canvas = document.createElement 'canvas'
    context = canvas.getContext '2d'

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

            SCENE.update difference/1000.0

            now = _now

        window.requestAnimationFrame update



    class Scene

        constructor: () ->
            @elements = []
            @_add = []
            @_remove = []

        update: (t) ->
            for element in @_add
                console.log "ADD", element._id, element.constructor.name
                element._scene = @
                @elements.push element
            for element in @_remove
                console.log "REMOVE", element._id, element.constructor.name
                element._scene = undefined
                @elements.remove element
            @_add = []
            @_remove = []

            for element in @elements
                element.update(t)

        addElement: (element) ->
            @_add.push element

        removeElement: (element) ->
            @_remove.push element

    class Element
        @auto_id = 0

        constructor: (x=undefined, y=undefined, width=undefined, height=undefined) ->
            @_id = ++Element.auto_id
            @_scene = undefined

        delete: () ->
            @_scene.removeElement @

        update: (t) -> console.warn "Not implemented" # interface


    class Avatar extends Element
        @width = 100
        @height = 100
        @speed = 500
        @reload = 100

        constructor: () ->
            super(100, 100, Avatar.width, Avatar.height)

            @x = 100
            @y = 100
            @width = Avatar.width
            @height = Avatar.height

            @ready = false
            @image = new Image()

            @image.onload = () ->
                console.log "IMAGE LOADED"

            @image.src = "http://placekitten.com/g/"+@width+"/"+@height


            @speed = Avatar.speed
            @reload = Avatar.reload

            @last_shot = 0

        update: (t) ->

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
                context.drawImage @image, @x, @y

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
            @_scene.addElement new Bullet @x + @width, @y + @height/2

    class Bullet extends Element
        @width = 20
        @height = 5
        @speed = 1000

        constructor: (x, y) ->

            @x = x
            @y = y
            @width = Bullet.width
            @height = Bullet.height

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

        update: (t) ->

            if not @ready
                @checkImage()

            @x += @speed * t

            if not @ready
                @checkImage()

            if @ready
                context.drawImage @image, @x, @y


    SCENE = new Scene()
    AVATAR = new Avatar()
    SCENE.addElement AVATAR

    update()

    width: width
    height: height
    canvas: canvas
    context: context